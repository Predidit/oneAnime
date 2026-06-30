import 'dart:io';

// Work around https://github.com/flutter/flutter/issues/188060.
const _ffiStructs = <String>[
  '_WindowCreationRequest',
  '_Size',
  '_Offset',
  '_Rect',
  '_Constraints',
];

void main() {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot == null || flutterRoot.isEmpty) {
    stderr.writeln('FLUTTER_ROOT is not set.');
    exitCode = 1;
    return;
  }

  final sourceFile = File(
    '$flutterRoot/packages/flutter/lib/src/widgets/_window_macos.dart',
  );
  if (!sourceFile.existsSync()) {
    stderr.writeln('Flutter macOS windowing source was not found.');
    exitCode = 1;
    return;
  }

  var source = sourceFile.readAsStringSync();
  var changed = false;

  for (final struct in _ffiStructs) {
    final declaration = 'final class $struct extends Struct {';
    final retainedDeclaration = "@pragma('vm:entry-point')\n$declaration";

    if (source.contains(retainedDeclaration)) {
      continue;
    }

    if (declaration.allMatches(source).length != 1) {
      stderr.writeln('Expected one declaration for $struct.');
      exitCode = 1;
      return;
    }

    source = source.replaceFirst(declaration, retainedDeclaration);
    changed = true;
  }

  if (changed) {
    sourceFile.writeAsStringSync(source);
    stdout.writeln('Patched Flutter macOS AOT FFI retention.');
  } else {
    stdout.writeln('Flutter macOS AOT FFI retention is already patched.');
  }
}
