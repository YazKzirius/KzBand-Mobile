//Imports
import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../LiveState/SessionState.dart';

const String serviceUuid =
    "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
const String characteristicUuid =
    "beb5483e-36e1-4688-b7f5-ea07361b26a8";

//Bluetooth recording process
class BleRecorder {
  BleRecorder._();
  static final BleRecorder instance = BleRecorder._();

  final SessionState _session = SessionState.instance;

  final Map<String, StreamSubscription<List<int>>> _subs = {};
  final Map<String, StringBuffer> _buffers = {};

  //Live packet stream for UI
  final StreamController<String> _packetStreamController =
  StreamController<String>.broadcast();

  Stream<String> get packetStream => _packetStreamController.stream;

  Future<void> attachDevice(BluetoothDevice device) async {
    if (_subs.containsKey(device.remoteId.str)) return;

    final services = await device.discoverServices();
    for (final s in services) {
      if (s.uuid.toString() == serviceUuid) {
        for (final c in s.characteristics) {
          if (c.uuid.toString() == characteristicUuid) {
            _buffers[device.remoteId.str] = StringBuffer();
            await c.setNotifyValue(true);

            _subs[device.remoteId.str] =
                c.lastValueStream.listen((data) {
                  _onData(device, data);
                });
            return;
          }
        }
      }
    }
  }

  void _onData(BluetoothDevice device, List<int> data) {
    final buffer = _buffers[device.remoteId.str]!;
    buffer.write(utf8.decode(data));

    while (buffer.toString().contains('\n')) {
      final idx = buffer.toString().indexOf('\n');
      final line = buffer.toString().substring(0, idx).trim();
      buffer.clear();

      if (line.isEmpty) continue;

      // Constant signal broadcast
      _packetStreamController.add(line);

      if (_session.isRunning) {
        _session.addPacket(line);
      }
    }
  }

  void dispose() {
    for (final s in _subs.values) {
      s.cancel();
    }
    _packetStreamController.close();
  }
}