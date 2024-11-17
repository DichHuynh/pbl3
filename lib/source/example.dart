import 'dart:async';
import 'dart:isolate';

void main() async {
  final student = await Student.spawn();
  print(await student.calculateFibonacci(10)); // Tính số Fibonacci thứ 10
  print(await student.isEven(42)); // Kiểm tra số chẵn cho 42
  print(await student.calculateFibonacci(15)); // Tính số Fibonacci thứ 15
  print(await Future.wait([student.isEven(19), student.isEven(20)])); // Kiểm tra nhiều số chẵn
  student.close();
}

class Student {
  final SendPort _commands;
  final ReceivePort _responses;
  final Map<int, Completer<Object?>> _activeRequests = {};
  int _idCounter = 0;
  bool _closed = false;

  Future<Object?> calculateFibonacci(int n) async {
    if (_closed) throw StateError('Closed');
    final completer = Completer<Object?>.sync();
    final id = _idCounter++;
    _activeRequests[id] = completer;
    _commands.send((id, 'fibonacci', n));
    return await completer.future;
  }

  Future<Object?> isEven(int number) async {
    if (_closed) throw StateError('Closed');
    final completer = Completer<Object?>.sync();
    final id = _idCounter++;
    _activeRequests[id] = completer;
    _commands.send((id, 'isEven', number));
    return await completer.future;
  }

  static Future<Student> spawn() async {
    final initPort = RawReceivePort();
    final connection = Completer<(ReceivePort, SendPort)>.sync();
    initPort.handler = (initialMessage) {
      final commandPort = initialMessage as SendPort;
      connection.complete((
        ReceivePort.fromRawReceivePort(initPort),
        commandPort,
      ));
    };

    try {
      await Isolate.spawn(_startRemoteIsolate, (initPort.sendPort));
    } on Object {
      initPort.close();
      rethrow;
    }

    final (ReceivePort receivePort, SendPort sendPort) =
        await connection.future;

    return Student._(receivePort, sendPort);
  }

  Student._(this._responses, this._commands) {
    _responses.listen(_handleResponsesFromIsolate);
  }

  void _handleResponsesFromIsolate(dynamic message) {
    final (int id, Object? response) = message as (int, Object?);
    final completer = _activeRequests.remove(id)!;

    if (response is RemoteError) {
      completer.completeError(response);
    } else {
      completer.complete(response);
    }

    if (_closed && _activeRequests.isEmpty) _responses.close();
  }

  static void _handleCommandsToIsolate(
    ReceivePort receivePort,
    SendPort sendPort,
  ) {
    receivePort.listen((message) {
      if (message == 'shutdown') {
        receivePort.close();
        return;
      }

      final (int id, String task, int value) = message as (int, String, int);

      try {
        if (task == 'fibonacci') {
          final result = _fibonacci(value);
          sendPort.send((id, result));
        } else if (task == 'isEven') {
          final result = value % 2 == 0;
          sendPort.send((id, result));
        }
      } catch (e) {
        sendPort.send((id, RemoteError(e.toString(), '')));
      }
    });
  }

  static void _startRemoteIsolate(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    _handleCommandsToIsolate(receivePort, sendPort);
  }

  void close() {
    if (!_closed) {
      _closed = true;
      _commands.send('shutdown');
      if (_activeRequests.isEmpty) _responses.close();
      print('--- port closed --- ');
    }
  }

  static int _fibonacci(int n) {
    if (n <= 1) return n;
    int a = 0, b = 1;
    for (int i = 2; i <= n; i++) {
      int temp = a + b;
      a = b;
      b = temp;
    }
    return b;
  }
}
