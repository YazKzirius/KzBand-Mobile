import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConnectedDevices {
  ConnectedDevices._();
  static final ConnectedDevices instance = ConnectedDevices._();

  final List<BluetoothDevice> devices = [];

  void add(BluetoothDevice device) {
    if (!devices.contains(device)) {
      devices.add(device);
    }
  }

  void remove(BluetoothDevice device) {
    devices.remove(device);
  }
}