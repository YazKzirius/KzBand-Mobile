import 'dart:math';

class SessionRecord {
  final String userId;
  final DateTime startTime;
  DateTime? endTime;
  final List<String> packets;

  SessionRecord({
    required this.userId,
    required this.startTime,
    required this.packets,
    this.endTime,
  });

  String toJsonString() {
    return '''
{
  "userId": "$userId",
  "startTime": "${startTime.toIso8601String()}",
  "endTime": "${endTime?.toIso8601String()}",
  "totalSamples": ${packets.length}
}
''';
  }
}

class SessionState {
  SessionState._();
  static final SessionState instance = SessionState._();

  bool isRunning = false;
  SessionRecord? _activeSession;
  final List<SessionRecord> completedSessions = [];

  String _generateUserId() {
    final r = Random().nextInt(90000) + 10000;
    return "U$r";
  }

  void startSession() {
    isRunning = true;
    _activeSession = SessionRecord(
      userId: _generateUserId(),
      startTime: DateTime.now(),
      packets: [],
    );
  }

  void stopSession() {
    if (_activeSession == null) return;
    _activeSession!.endTime = DateTime.now();
    completedSessions.add(_activeSession!);
    _activeSession = null;
    isRunning = false;
  }

  void addPacket(String packet) {
    if (isRunning && _activeSession != null) {
      _activeSession!.packets.add(packet);
    }
  }

  void deleteSession(SessionRecord session) {
    completedSessions.remove(session);
  }

  SessionRecord? get activeSession => _activeSession;
}