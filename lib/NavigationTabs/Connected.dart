import 'package:flutter/material.dart';
import 'package:kzband/LiveState/ConnectedDevices.dart';
import 'package:kzband/screens/live_dashboard.dart';

class ConnectedTab extends StatelessWidget {
  const ConnectedTab({super.key});

  @override
  Widget build(BuildContext context) {
    final devices = ConnectedDevices.instance.devices;

    return Scaffold(
      backgroundColor: const Color(0xFF060E13),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: devices.isEmpty
            ? const Center(
          child: Text(
            "No connected devices",
            style: TextStyle(color: Colors.white30),
          ),
        )
            : ListView(
          children: devices.map((d) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1B24),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                title: Text(
                  d.platformName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.white54,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LiveDashboard(device: d),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}