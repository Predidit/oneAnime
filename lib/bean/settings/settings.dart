import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hive/hive.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:oneanime/i18n/strings.g.dart';

class SetSwitchItem extends StatefulWidget {
  final String? title;
  final String? subTitle;
  final String? setKey;
  final bool? defaultVal;
  final Function? callFn;
  final bool? needReboot;

  const SetSwitchItem({
    this.title,
    this.subTitle,
    this.setKey,
    this.defaultVal,
    this.callFn,
    this.needReboot,
    Key? key,
  }) : super(key: key);

  @override
  State<SetSwitchItem> createState() => _SetSwitchItemState();
}

class _SetSwitchItemState extends State<SetSwitchItem> {
  // ignore: non_constant_identifier_names
  Box Setting = GStorage.setting;
  late bool val;
  late Translations i18n;

  @override
  void initState() {
    super.initState();
    i18n = Translations.of(context);
    val = Setting.get(widget.setKey, defaultValue: widget.defaultVal ?? false);
  }

  void switchChange(value) async {
    val = value ?? !val;
    await Setting.put(widget.setKey, val);
    if (widget.callFn != null) {
      widget.callFn!.call(val);
    }
    if (widget.needReboot != null && widget.needReboot!) {
      SmartDialog.showToast(i18n.toast.needReboot);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.titleMedium!;
    TextStyle subTitleStyle = Theme.of(context)
        .textTheme
        .labelMedium!
        .copyWith(color: Theme.of(context).colorScheme.outline);
    return ListTile(
      enableFeedback: true,
      onTap: () => switchChange(null),
      title: Text(widget.title!, style: titleStyle),
      subtitle: widget.subTitle != null
          ? Text(widget.subTitle!, style: subTitleStyle)
          : null,
      trailing: Transform.scale(
        alignment: Alignment.centerRight, // 缩放Switch的大小后保持右侧对齐, 避免右侧空隙过大
        scale: 0.8,
        child: Switch(
          value: val,
          onChanged: (val) => switchChange(val),
        ),
      ),
    );
  }
}

class SelectDialog<T> extends StatefulWidget {
  final T value;
  final String title;
  final List<dynamic> values;
  const SelectDialog(
      {super.key,
      required this.value,
      required this.values,
      required this.title});

  @override
  _SelectDialogState<T> createState() => _SelectDialogState<T>();
}

class _SelectDialogState<T> extends State<SelectDialog<T>> {
  late T _tempValue;
  late Translations i18n;

  @override
  void initState() {
    super.initState();
    i18n = Translations.of(context);
    _tempValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.titleMedium!;

    return AlertDialog(
      title: Text(widget.title),
      contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      content: StatefulBuilder(builder: (context, StateSetter setState) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i in widget.values) ...[
                RadioListTile(
                  value: i['value'],
                  title: Text(i['title'], style: titleStyle),
                  groupValue: _tempValue,
                  onChanged: (value) {
                    setState(() {
                      _tempValue = value as T;
                    });
                  },
                ),
              ]
            ],
          ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            i18n.dialog.dismiss,
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _tempValue),
          child: Text(i18n.dialog.confirm),
        )
      ],
    );
  }
}

