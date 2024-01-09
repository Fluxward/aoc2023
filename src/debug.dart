import 'dart:async';
import 'dart:io';
import 'dart:isolate';

ReceivePort _timerRecvPort = ReceivePort();
Isolate? _timerIsolate;

Future<SendPort> getTimerSendPort(Duration period) async {
  _timerIsolate = await Isolate.spawn<SendPort>((sp) {
    ReceivePort port = ReceivePort();
    sp.send(port.sendPort);
    Stopwatch sw = Stopwatch()..start();

    String message = "";
    Timer.periodic(period, (timer) {
      stderr.writeln("t: ${sw.elapsed}, $message");
    });

    port.listen((msg) {
      message = msg.toString();
    });
  }, _timerRecvPort.sendPort);

  return await _timerRecvPort.first;
}

void cleanup([int priority = Isolate.immediate]) {
  _timerIsolate?.kill(priority: priority);
}
