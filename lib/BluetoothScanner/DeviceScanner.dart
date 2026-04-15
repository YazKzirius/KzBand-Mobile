import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:kzband/LiveState/ConnectedDevices.dart';

class DeviceScannerModal extends StatefulWidget {
  const DeviceScannerModal({super.key});

  @override
  State<DeviceScannerModal> createState() => _DeviceScannerModalState();
}

class _DeviceScannerModalState extends State<DeviceScannerModal> {
  List<ScanResult> results = [];

  @override
  void initState() {
    super.initState();

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 6));

    FlutterBluePlus.scanResults.listen((r) {
      if (!mounted) return;

      setState(() {
        results = r.where((e) {
          final name = e.device.platformName.isNotEmpty
              ? e.device.platformName
              : e.device.advName;

          return name.startsWith("KzBand") || name.startsWith("KzHand");
        }).toList();
      });
    });
  }

  Future<void> connect(BluetoothDevice device) async {
    await FlutterBluePlus.stopScan();
    await device.connect(license: License.free);
    await device.requestMtu(185);
    ConnectedDevices.instance.add(device);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Available Devices",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: results.map((r) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      title: Text(r.device.platformName),
                      trailing: TextButton(
                        onPressed: () => connect(r.device),
                        child: const Text("CONNECT"),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}