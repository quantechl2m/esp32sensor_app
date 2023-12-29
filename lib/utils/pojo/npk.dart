import 'dart:ui';

import 'package:esp32sensor/utils/constants/constants.dart';

class NPKData {
  final String label;
  final String symbol;
  final int value;
  final Color color;
  final Status status;

  NPKData(this.label, this.symbol, this.value, this.color, this.status);
}

class NPKRange {
  final String label;
  final int start;
  final int end;
  final Color color;

  NPKRange(this.label, this.start, this.end, this.color);
}

