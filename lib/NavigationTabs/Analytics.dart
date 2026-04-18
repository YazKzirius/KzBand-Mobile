import 'package:flutter/material.dart';
import 'package:kzband/LiveState/SessionState.dart';
import 'package:kzband/Utilities/csv_export.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';

class AnalyticsTab extends StatelessWidget {
  const AnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionState = SessionState.instance;

    return Scaffold(
      backgroundColor: const Color(0xFF060E13),
      body: sessionState.completedSessions.isEmpty
          ? const Center(
        child: Text(
          "No recorded sessions",
          style: TextStyle(color: Colors.white30),
        ),
      )
          : ListView.builder(
        itemCount: sessionState.completedSessions.length,
        itemBuilder: (_, index) {
          final session = sessionState.completedSessions[index];

          return Card(
            color: const Color(0xFF0D1B24),
            margin: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            child: ListTile(
              title: Text(
                "Session ${index + 1} — ${session.userId}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Samples: ${session.packets.length}",
                style: const TextStyle(color: Colors.white54),
              ),

              // ✅ EXPORT ICON PER SESSION
              trailing: IconButton(
                icon: const Icon(
                  Icons.download,
                  color: Colors.greenAccent,
                ),
                tooltip: "Export session as CSV",
                onPressed: () {
                  final csv = sessionToCsv(session);
                  final filename =
                      "session_${session.userId}_${session.startTime.toIso8601String()}.csv";

                  final bytes = utf8.encode(csv);

                  final file = XFile.fromData(
                    bytes,
                    mimeType: 'text/csv',
                    name: filename, // ✅ filename belongs HERE
                  );

                  Share.shareXFiles(
                    [file],
                    subject: "KzBand Session Export",
                  );

                },
              ),
            ),
          );
        },
      ),
    );
  }
}