import 'package:flutter/material.dart';
import 'package:kzband/LiveState/SessionState.dart';

class AnalyticsTab extends StatefulWidget {
  const AnalyticsTab({super.key});

  @override
  State<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<AnalyticsTab> {
  final session = SessionState.instance;
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060E13),
      body: session.completedSessions.isEmpty
          ? const Center(
        child: Text(
          "No recorded sessions",
          style: TextStyle(color: Colors.white30),
        ),
      )
          : ListView.builder(
        itemCount: session.completedSessions.length,
        itemBuilder: (_, i) {
          final s = session.completedSessions[i];
          final expanded = expandedIndex == i;

          return Card(
            color: const Color(0xFF0D1B24),
            margin: const EdgeInsets.all(12),
            child: Column(
              children: [
                ListTile(
                  title: Text("User ${s.userId}"),
                  subtitle: Text(
                    "Samples: ${s.packets.length}",
                    style: const TextStyle(color: Colors.white54),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            session.deleteSession(s);
                            expandedIndex = null;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          expanded ? Icons.expand_less : Icons.expand_more,
                          color: Colors.white54,
                        ),
                        onPressed: () {
                          setState(() {
                            expandedIndex = expanded ? null : i;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                if (expanded)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        s.toJsonString(),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}