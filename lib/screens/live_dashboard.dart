import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:kzband/LiveState/SessionState.dart';

const String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
const String CHAR_TX_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";

class LiveDashboard extends StatefulWidget {
  final BluetoothDevice device;
  final SessionState session;

  const LiveDashboard({
    super.key,
    required this.device,
    required this.session,
  });

  @override
  State<LiveDashboard> createState() => _LiveDashboardState();
}

class _LiveDashboardState extends State<LiveDashboard> {
  String bpm = "--", gsr = "--", temp = "--";
  String accMag = "--", gyroMag = "--";

  final List<String> displayPackets = []; // UI‑only (max 10)
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

      if (line.isNotEmpty) {
        _parse(line);

        // ✅ UI display: last 10 only
        setState(() {
          displayPackets.add(line);
          if (displayPackets.length > 10) {
            displayPackets.removeAt(0);
          }
        });

        // ✅ FULL storage if recording
        if (widget.session.isRunning) {
          widget.session.addPacket(line);
        }
      }
    }
  }

  void _parse(String raw) {
    final kvs = raw.split(',');

    setState(() {
      for (final p in kvs) {
        final kv = p.split(':');
        if (kv.length != 2) continue;
        switch (kv[0]) {
          case 'BPM': bpm = kv[1]; break;
          case 'GSR': gsr = kv[1]; break;
          case 'Tmp': temp = kv[1]; break;
          case 'AccMag': accMag = kv[1]; break;
          case 'GyroMag': gyroMag = kv[1]; break;
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
    final bool recording = widget.session.isRunning;

    return Scaffold(
      backgroundColor: const Color(0xFF060E13),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ───── MODE INDICATOR ─────
          Text(
            recording
                ? "RECORDING SESSION"
                : "RESTING CHECK – VERIFY SIGNALS",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: recording ? Colors.greenAccent : Colors.orangeAccent,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _card("BPM", bpm),
          _card("GSR", gsr),
          _card("TEMP", temp),
          _card("ACC MAG", accMag),
          _card("GYRO MAG", gyroMag),

          const SizedBox(height: 16),

          // ───── LAST 10 PACKETS (DISPLAY ONLY) ─────
          const Text(
            "LAST RECEIVED PACKETS (DISPLAY LIMIT 10)",
            style: TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 6),

          ...displayPackets.map(
                (p) => Text(
              p,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B24),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54)),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}