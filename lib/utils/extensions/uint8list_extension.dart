import 'dart:typed_data';

import 'package:flutter/material.dart';

extension Uint8ListExtension on Uint8List {
  Color getAverageColor() {
    int pixelCount = length ~/ 4;
    int totalRed = 0;
    int totalGreen = 0;
    int totalBlue = 0;

    for (int i = 0; i < length - 4; i += 4) {
      int red = this[i];
      int green = this[i + 1];
      int blue = this[i + 2];
      
      totalRed += red;
      totalGreen += green;
      totalBlue += blue;
    }

    int averageRed = totalRed ~/ pixelCount;
    int averageGreen = totalGreen ~/ pixelCount;
    int averageBlue = totalBlue ~/ pixelCount;

    print("AVG COLOR: ${Color.fromRGBO(averageRed, averageGreen, averageBlue, 1)}");

    return Color.fromRGBO(averageRed, averageGreen, averageBlue, 1);
  }
}