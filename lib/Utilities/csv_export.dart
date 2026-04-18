import 'package:kzband/LiveState/SessionState.dart';

String sessionToCsv(SessionRecord session) {
  final header = [
    'timestamp_ms',
    'sequence',
    'device',
    'bpm',
    'gsr_raw',
    'gsr_clean',
    'gsr_phasic',
    'temperature_c',
    'acc_mag',
    'gyro_mag',
    'motion_state',
  ].join(',');

  final rows = session.packets.map((packet) {
    final fields = {
      'TS': '',
      'SEQ': '',
      'BPM': '',
      'GSR_RAW': '',
      'GSR_CLEAN': '',
      'GSR_PHASIC': '',
      'Tmp': '',
      'AccMag': '',
      'GyroMag': '',
      'Motion': '',
    };

    for (final part in packet.split(',')) {
      final kv = part.split(':');
      if (kv.length == 2 && fields.containsKey(kv[0])) {
        fields[kv[0]] = kv[1];
      }
    }

    return [
      fields['TS'],
      fields['SEQ'],
      session.userId,
      fields['BPM'],
      fields['GSR_RAW'],
      fields['GSR_CLEAN'],
      fields['GSR_PHASIC'],
      fields['Tmp'],
      fields['AccMag'],
      fields['GyroMag'],
      fields['Motion'],
    ].join(',');
  }).toList();

  return ([header, ...rows]).join('\n');
}