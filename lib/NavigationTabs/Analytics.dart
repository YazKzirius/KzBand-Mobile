import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kzband/LiveState/SessionState.dart';
import 'package:kzband/Utilities/csv_export.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class AnalyticsTab extends StatelessWidget {
  const AnalyticsTab({super.key});

  // ✅ Compute columns + rows for each CSV
  Map<String, Map<String, int>> _csvStats(Map<String, String> csvs) {
    final stats = <String, Map<String, int>>{};

    csvs.forEach((key, csv) {
      final lines = csv.trim().isEmpty ? [] : csv.trim().split('\n');

      if (lines.isEmpty) {
        stats[key] = {'columns': 0, 'rows': 0};
      } else {
        final columns = lines.first.split(',').length;
        final rows = lines.length - 1; // exclude header
        stats[key] = {'columns': columns, 'rows': rows};
      }
    });

    return stats;
  }

  Future<void> _export(SessionRecord session) async {
    final csvs = sessionToCsvByDevice(session);
    final stats = _csvStats(csvs);

    final dir = await getTemporaryDirectory();
    final ts =
    session.startTime.toIso8601String().replaceAll(':', '-');

    final files = <XFile>[];

    // ✅ KzHand CSV
    if ((stats['KzHand']?['rows'] ?? 0) > 0) {
      final file = File(
        '${dir.path}/session_${session.userId}_KzHand_$ts.csv',
      );
      await file.writeAsString(csvs['KzHand']!);
      files.add(XFile(file.path));
    }

    // ✅ KzBand CSV
    if ((stats['KzBand']?['rows'] ?? 0) > 0) {
      final file = File(
        '${dir.path}/session_${session.userId}_KzBand_$ts.csv',
      );
      await file.writeAsString(csvs['KzBand']!);
      files.add(XFile(file.path));
    }

    if (files.isNotEmpty) {
      await Share.shareXFiles(
        files,
        subject: 'KzBand Session ${session.userId} CSV Export',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = SessionState.instance;

    return Scaffold(
      backgroundColor: const Color(0xFF060E13),
      body: state.completedSessions.isEmpty
          ? const Center(
        child: Text(
          'No recorded sessions',
          style: TextStyle(color: Colors.white30),
        ),
      )
          : ListView.builder(
        itemCount: state.completedSessions.length,
        itemBuilder: (_, index) {
          final session = state.completedSessions[index];

          final csvs = sessionToCsvByDevice(session);
          final stats = _csvStats(csvs);

          final bandCols = stats['KzBand']?['columns'] ?? 0;
          final bandRows = stats['KzBand']?['rows'] ?? 0;

          final handCols = stats['KzHand']?['columns'] ?? 0;
          final handRows = stats['KzHand']?['rows'] ?? 0;

          return Card(
            color: const Color(0xFF0D1B24),
            margin: const EdgeInsets.all(12),
            child: ListTile(
              title: Text(
                'Session ${index + 1} — ${session.userId}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'KzBandData: $bandCols cols, $bandRows rows\n'
                    'KzHandData: $handCols cols, $handRows rows',
                style: const TextStyle(color: Colors.white54),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.download,
                  color: Colors.greenAccent,
                ),
                tooltip: 'Export CSV files',
                onPressed: () => _export(session),
              ),
            ),
          );
        },
      ),
    );
  }
}
