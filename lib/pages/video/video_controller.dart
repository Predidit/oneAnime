import 'package:mobx/mobx.dart';
import 'package:oneanime/bean/anime/anime_info.dart';

part 'video_controller.g.dart';

class VideoController = _VideoController with _$VideoController;

abstract class _VideoController with Store {

  String videoUrl = '';
  String videoCookie = '';
  
}