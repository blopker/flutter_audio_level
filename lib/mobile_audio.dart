import 'dart:async';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

Stream<double> getAudioLevelStream() {
  late StreamController<double> controller;
  Timer? timer;
  const platform = MethodChannel('samples.flutter.dev/audioLevel');
  callback(double level) {
    controller.add(level);
  }

  void start() async {
    await Permission.microphone.request();
    await platform.invokeMethod('initializeAudioLevel');
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      var level = await platform.invokeMethod('getAudioLevel');
      callback(level);
    });
  }

  void stop() async {
    await platform.invokeMethod('stopAudioLevel');
    if (timer != null) {
      timer!.cancel();
    }
  }

  controller =
      StreamController<double>.broadcast(onListen: start, onCancel: stop);

  return controller.stream;
}
