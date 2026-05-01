import 'package:flutter_blue_plus/flutter_blue_plus.dart';

//This class is used to store the connected devices for the app and analysis
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