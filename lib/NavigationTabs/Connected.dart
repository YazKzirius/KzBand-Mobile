//Imports
import 'package:flutter/material.dart';
import 'package:kzband/LiveState/ConnectedDevices.dart';
import 'package:kzband/LiveState/SessionState.dart';
import 'package:kzband/BluetoothScanner/BleRecorder.dart';
import 'package:kzband/screens/live_dashboard.dart';

//This loads up all the connected devices and provides access to current signals
class ConnectedTab extends StatefulWidget {
  const ConnectedTab({super.key});

  @override
  State<ConnectedTab> createState() => _ConnectedTabState();
}

class _ConnectedTabState extends State<ConnectedTab> {
  final session = SessionState.instance;

  @override
  Widget build(BuildContext context) {
    final devices = ConnectedDevices.instance.devices;

    //Attach ALL devices to recorder
    for (final d in devices) {
      BleRecorder.instance.attachDevice(d);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF060E13),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            session.isRunning ? "SESSION RUNNING" : "SESSION STOPPED",
            style: TextStyle(
              color: session.isRunning
                  ? Colors.greenAccent
                  : Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: !session.isRunning
                      ? () => setState(session.startSession)
                      : null,
                  child: const Text("START"),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: session.isRunning
                      ? () => setState(session.stopSession)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  child: const Text("STOP"),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white12),
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (_, i) {
                final d = devices[i];
                return ListTile(
                  title: Text(d.platformName,
                      style: const TextStyle(color: Colors.white)),
                  subtitle: const Text(
                    "Tap to view live data",
                    style: TextStyle(color: Colors.white54),
                  ),
                  trailing: const Icon(Icons.chevron_right,
                      color: Colors.white54),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LiveDashboard(device: d),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}