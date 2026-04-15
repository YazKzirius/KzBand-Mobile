import 'package:flutter/material.dart';
import 'package:kzband/LiveState/ConnectedDevices.dart';
import 'package:kzband/LiveState/SessionState.dart';
import 'package:kzband/screens/live_dashboard.dart';

class ConnectedTab extends StatefulWidget {
  const ConnectedTab({super.key});

  @override
  State<ConnectedTab> createState() => _ConnectedTabState();
}

class _ConnectedTabState extends State<ConnectedTab> {
  final SessionState session = SessionState.instance;

  @override
  Widget build(BuildContext context) {
    final devices = ConnectedDevices.instance.devices;
    final bool bothConnected = devices.length >= 2;

    return Scaffold(
      backgroundColor: const Color(0xFF060E13),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),

          // ───── SESSION STATUS ─────
          Center(
            child: Text(
              session.isRunning ? "SESSION RUNNING" : "SESSION STOPPED",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: session.isRunning
                    ? Colors.greenAccent
                    : Colors.redAccent,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ───── START / STOP CONTROLS ─────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: bothConnected && !session.isRunning
                        ? () {
                      setState(() {
                        session.startSession();
                      });

                      // ✅ FORCE recording view on START
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LiveDashboard(
                            device: devices.first,
                            session: session, // ALWAYS RECORD
                          ),
                        ),
                      );
                    }
                        : null,
                    child: const Text("START"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: session.isRunning
                        ? () {
                      setState(() {
                        session.stopSession();
                      });
                    }
                        : null,
                    child: const Text("STOP"),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ───── CONNECTION WARNING ─────
          if (!bothConnected)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Both KzBand and KzHand must be connected to start a session.",
                style: TextStyle(color: Colors.white30),
              ),
            ),

          const SizedBox(height: 12),

          // ───── LAST SESSION SUMMARY ─────
          if (!session.isRunning &&
              session.completedSessions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                session.completedSessions.last.toJsonString(),
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ),

          const Divider(color: Colors.white12),

          // ───── CONNECTED DEVICES LIST (VIEW ONLY) ─────
          Expanded(
            child: devices.isEmpty
                ? const Center(
              child: Text(
                "No connected devices",
                style: TextStyle(color: Colors.white30),
              ),
            )
                : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (_, index) {
                final device = devices[index];

                return ListTile(
                  title: Text(
                    device.platformName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text("Tap to check live sensor signals",
                    style: TextStyle(color: Colors.white54),
                  ),
                  trailing: const Icon(
                    Icons.bluetooth_connected,
                    color: Colors.white54,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LiveDashboard(
                          device: device,
                          session: session,
                        ),
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