import 'dart:async';
import 'dart:math';

Stream<double> getAudioLevelStream() {
  late StreamController<double> controller;
  Timer? timer;
  var random = Random();
  callback(double level) {
    controller.add(level);
  }

  void start() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      callback(random.nextDouble());
    });
  }

  void stop() {
    if (timer != null) {
      timer!.cancel();
    }
  }

  controller =
      StreamController<double>.broadcast(onListen: start, onCancel: stop);

  return controller.stream;
}
