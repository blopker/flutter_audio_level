import 'dart:async';
import 'package:js/js.dart';

@JS('AudioLevels.getAudioLevel')
external _getAudioLevel(Function(double) callback);

@JS('AudioLevels.stopAudioStream')
external stopAudioStream();

Stream<double> getAudioLevelStream() {
  late StreamController<double> controller;
  callback(level) {
    controller.add(level);
  }

  void start() {
    _getAudioLevel(allowInterop(callback));
  }

  void stop() {
    stopAudioStream();
  }

  controller =
      StreamController<double>.broadcast(onListen: start, onCancel: stop);

  return controller.stream;
}
