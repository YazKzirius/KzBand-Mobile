//Imports
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:kzband/BluetoothScanner/BleRecorder.dart';

//This page displays the live data from the connected device
class LiveDashboard extends StatefulWidget {
  final BluetoothDevice device;

  const LiveDashboard({super.key, required this.device});

  @override
  State<LiveDashboard> createState() => _LiveDashboardState();
}

class _LiveDashboardState extends State<LiveDashboard> {
  StreamSubscription<String>? _sub;

  // Display values
  String bpm = "--";
  String temp = "--";
  String accMag = "--";
  String gyroMag = "--";
  String edaRaw = "--";
  String edaClean = "--";
  String edaPhasic = "--";

  @override
  void initState() {
    super.initState();

    final bool isKzHand =
    widget.device.platformName.startsWith("KzHand");

    _sub = BleRecorder.instance.packetStream.listen((packet) {
      final map = <String, String>{};
      for (final part in packet.split(',')) {
        final kv = part.split(':');
        if (kv.length == 2) map[kv[0]] = kv[1];
      }

      if (isKzHand && map.containsKey('EDA_FINGER_RAW')) {
        setState(() {
          edaRaw = map['EDA_FINGER_RAW'] ?? edaRaw;
          edaClean = map['EDA_FINGER_CLEAN'] ?? edaClean;
          edaPhasic = map['EDA_FINGER_PHASIC'] ?? edaPhasic;
        });
      }

      if (!isKzHand && map.containsKey('EDA_FOREHEAD_RAW')) {
        setState(() {
          bpm = map['BPM'] ?? bpm;
          temp = map['Tmp'] ?? temp;
          accMag = map['AccMag'] ?? accMag;
          gyroMag = map['GyroMag'] ?? gyroMag;
          edaRaw = map['EDA_FOREHEAD_RAW'] ?? edaRaw;
          edaClean =
              map['EDA_FOREHEAD_CLEAN'] ?? edaClean;
          edaPhasic =
              map['EDA_FOREHEAD_PHASIC'] ?? edaPhasic;
        });
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
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
          Text(label,
              style: const TextStyle(color: Colors.white54)),
          Text(value,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isKzHand =
    widget.device.platformName.startsWith("KzHand");

    return Scaffold(
      backgroundColor: const Color(0xFF060E13),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.device.platformName),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "RESTING CHECK – LIVE SIGNAL",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.orangeAccent,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          if (isKzHand) ...[
            _card("EDA RAW", edaRaw),
            _card("EDA CLEAN", edaClean),
            _card("EDA PHASIC", edaPhasic),
          ] else ...[
            _card("BPM", bpm),
            _card("EDA RAW", edaRaw),
            _card("EDA CLEAN", edaClean),
            _card("EDA PHASIC", edaPhasic),
            _card("TEMP (°C)", temp),
            _card("ACC MAG", accMag),
            _card("GYRO MAG", gyroMag),
          ],
        ],
      ),
    );
  }
}