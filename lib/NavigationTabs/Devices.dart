//imports
import 'package:flutter/material.dart';
import 'package:kzband/BluetoothScanner/DeviceScanner.dart';

//This gives users the ability to add specific devices and connect them via bluetooth
class DevicesTab extends StatelessWidget {
  const DevicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060E13),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const Spacer(),
              Image.asset('assets/KzBand.png', height: 160),
              const SizedBox(height: 20),
              const Text(
                "KzBand",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 6),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => const DeviceScannerModal(),
                  );
                },
                child: const Text("ADD KZBAND DEVICE"),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}