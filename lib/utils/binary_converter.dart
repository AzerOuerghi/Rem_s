import 'dart:typed_data';

class BinaryConverter {
  static const int MAGIC_WORD = 0xDEADBEEF;
  static const int MAX_VALVES_PER_STEP = 5;
  static const int NUM_INTENSITIES = 1;
  static const int MAX_MASSAGE_NAME_LEN = 32;

  static final Map<int, int> JSON_BLADDER_ID_TO_C_VALVE_VALUE = {
    1: 0, // VALVE_1
    2: 1, // VALVE_2
    3: 2, // VALVE_3
    4: 3, // VALVE_4
    5: 4, // VALVE_5
    6: 5, // VALVE_6
    7: 6, // VALVE_8 (JSON bladder 7 maps to C's VALVE_8)
    8: 7, // VALVE_9
    9: 8, // VALVE_10
  };

  static const Map<String, int> VALVE_STATE_TYPE_C = {
    '': 0,  // VALVE_OFF
    'X': 1, // VALVE_ON
    'P': 2, // VALVE_PULSE
    'FP': 3 // VALVE_FULLPULSE
  };

  static ByteData convertJsonToBinary(Map<String, dynamic> data) {
    final builder = BytesBuilder();
    final byteData = ByteData(1024); // Initial buffer size
    int offset = 0;

    // Magic Word (start)
    byteData.setUint32(offset, MAGIC_WORD, Endian.little);
    offset += 4;

    // Number of steps
    final numSteps = data['totalSteps'] as int;
    byteData.setUint32(offset, numSteps, Endian.little);
    offset += 4;

    // Target zone (default to ZONE_ALL = 2)
    byteData.setUint32(offset, 2, Endian.little);
    offset += 4;

    // Massage name
    final name = (data['projectName'] as String).padRight(MAX_MASSAGE_NAME_LEN, '\0');
    for (int i = 0; i < MAX_MASSAGE_NAME_LEN; i++) {
      byteData.setUint8(offset + i, name.codeUnitAt(i));
    }
    offset += MAX_MASSAGE_NAME_LEN;

    // Steps data
    for (final step in data['steps'] as List) {
      // Step ID
      byteData.setUint8(offset, step['step_id'] as int);
      offset += 1;

      // Valve actions
      int actionCount = 0;
      for (final bladder in step['bladders'] as List) {
        if (actionCount >= MAX_VALVES_PER_STEP) break;

        final bladderId = bladder['bladder_id'] as int;
        final value = bladder['value'] as String;
        
        if (value.isNotEmpty && JSON_BLADDER_ID_TO_C_VALVE_VALUE.containsKey(bladderId)) {
          byteData.setUint8(offset, JSON_BLADDER_ID_TO_C_VALVE_VALUE[bladderId]!);
          byteData.setUint8(offset + 1, VALVE_STATE_TYPE_C[value]!);
          actionCount++;
          offset += 2;
        }
      }

      // Pad remaining valve actions
      while (actionCount < MAX_VALVES_PER_STEP) {
        byteData.setUint8(offset, 0); // Valve ID
        byteData.setUint8(offset + 1, 0); // VALVE_OFF
        actionCount++;
        offset += 2;
      }

      // Number of actions
      byteData.setUint32(offset, step['num_actions'] as int, Endian.little);
      offset += 4;

      // Pulse frequency
      byteData.setUint16(offset, step['frequency'].round(), Endian.little);
      offset += 2;

      // Intensity
      byteData.setUint8(offset, step['intensity'].round());
      offset += 1;

      // Duration
      byteData.setUint16(offset, step['duration_ms'] as int, Endian.little);
      offset += 2;
    }

    // Magic Word (end)
    byteData.setUint32(offset, MAGIC_WORD, Endian.little);
    offset += 4;

    return byteData.buffer.asByteData(0, offset);
  }
}
