import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

const String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
const String CHAR_TX_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";

class LiveDashboard extends StatefulWidget {
  final BluetoothDevice device;
  const LiveDashboard({super.key, required this.device});

  @override
  State<LiveDashboard> createState() => _LiveDashboardState();
}

class _LiveDashboardState extends State<LiveDashboard> {
  // Physiological
  String bpm = "--";
  String gsr = "--";
  String temp = "--";

  // Kinematics
  String accZ = "--";
  String accMag = "--";
  String gyroMag = "--";
  String angX = "--";
  String angY = "--";
  String angZ = "--";

  final StringBuffer buffer = StringBuffer();
  StreamSubscription<List<int>>? sub;
  BluetoothCharacteristic? char;

  @override
  void initState() {
    super.initState();
    _initBle();
  }

  Future<void> _initBle() async {
    final services = await widget.device.discoverServices();
    for (final s in services) {
      if (s.uuid.toString() == SERVICE_UUID) {
        for (final c in s.characteristics) {
          if (c.uuid.toString() == CHAR_TX_UUID) {
            char = c;
            await c.setNotifyValue(true);
            sub = c.lastValueStream.listen(_onData);
            return;
          }
        }
      }
    }
  }

  void _onData(List<int> data) {
    buffer.write(utf8.decode(data));
    while (buffer.toString().contains('\n')) {
      final idx = buffer.toString().indexOf('\n');
      final line = buffer.toString().substring(0, idx).trim();
      buffer.clear();
      if (line.isNotEmpty) _parse(line);
    }
  }

  void _parse(String raw) {
    final kvs = raw.split(',');
    if (!mounted) return;

    setState(() {
      for (final p in kvs) {
        final kv = p.split(':');
        if (kv.length != 2) continue;

        switch (kv[0]) {
          case 'BPM': bpm = kv[1]; break;
          case 'GSR': gsr = kv[1]; break;
          case 'Tmp': temp = kv[1]; break;
          case 'AccZ': accZ = kv[1]; break;
          case 'AccMag': accMag = kv[1]; break;
          case 'GyroMag': gyroMag = kv[1]; break;
          case 'AngX': angX = kv[1]; break;
          case 'AngY': angY = kv[1]; break;
          case 'AngZ': angZ = kv[1]; break;
        }
      }
    });
  }

  @override
  void dispose() {
    sub?.cancel();
    char?.setNotifyValue(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060E13),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.device.platformName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            // ───── PHYSIOLOGICAL ─────
            Row(
              children: [
                Expanded(
                  child: _dataCard("CARDIAC OUTPUT", bpm, "BPM"),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _dataCard("EDA / GSR", gsr, "RAW"),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _dataCard("SURFACE TEMP", temp, "°C"),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _dataCard("ACC MAG", accMag, "g"),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ───── IMU ─────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1B24),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "IMU KINEMATICS",
                    style: TextStyle(
                      color: Colors.white54,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("AccZ: $accZ g"),
                      Text("Gyro: $gyroMag °/s"),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _miniStat("PITCH", angX),
                      _miniStat("ROLL", angY),
                      _miniStat("YAW", angZ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dataCard(String title, String value, String unit) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B24),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "$value $unit",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}