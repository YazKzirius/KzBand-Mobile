import 'package:kzband/LiveState/SessionState.dart';

Map<String, String> sessionToCsvByDevice(SessionRecord session) {
  //Kzhand CSV metrics
  final kzHandHeader = [
    'timestamp_ms',
    'eda_finger_raw',
    'eda_finger_clean',
    'eda_finger_phasic',
  ].join(',');

  //Kzband CSV metrics
  final kzBandHeader = [
    'timestamp_ms',
    'bpm',
    'eda_forehead_raw',
    'eda_forehead_clean',
    'eda_forehead_phasic',
    'temperature_c',
    'acc_mag',
    'gyro_mag',
    'motion_state',
  ].join(',');

  final kzHandRows = <String>[];
  final kzBandRows = <String>[];

  //Processing data signals
  for (final packet in session.packets) {
    final fields = <String, String>{};

    for (final part in packet.split(',')) {
      final kv = part.split(':');
      if (kv.length == 2) {
        fields[kv[0]] = kv[1];
      }
    }

    //KzHand packet
    if (fields.containsKey('EDA_FINGER_RAW')) {
      kzHandRows.add([
        fields['TS'] ?? '',
        fields['EDA_FINGER_RAW'] ?? '',
        fields['EDA_FINGER_CLEAN'] ?? '',
        fields['EDA_FINGER_PHASIC'] ?? '',
      ].join(','));
    }

    //KzBand packet
    if (fields.containsKey('EDA_FOREHEAD_RAW')) {
      kzBandRows.add([
        fields['TS'] ?? '',
        fields['BPM'] ?? '',
        fields['EDA_FOREHEAD_RAW'] ?? '',
        fields['EDA_FOREHEAD_CLEAN'] ?? '',
        fields['EDA_FOREHEAD_PHASIC'] ?? '',
        fields['Tmp'] ?? '',
        fields['AccMag'] ?? '',
        fields['GyroMag'] ?? '',
        fields['Motion'] ?? '',
      ].join(','));
    }
  }

  return {
    'KzHand': ([kzHandHeader, ...kzHandRows]).join('\n'),
    'KzBand': ([kzBandHeader, ...kzBandRows]).join('\n'),
  };
}