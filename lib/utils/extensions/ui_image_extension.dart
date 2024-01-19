import 'package:flutter/material.dart';

import 'dart:ui' as ui;

extension UiImageExtension on ui.Image {
  Future<Color?> get averageColor async {
    final byteData = await toByteData(format: ui.ImageByteFormat.rawRgba);
    final buffer = byteData!.buffer.asUint8List();

    // Total color values
    var totalRed = 0;
    var totalGreen = 0;
    var totalBlue = 0;
    // var totalAlpha = 0;

    // Calculate total color values
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final pixelOffset = (y * width + x) * 4;
        totalRed += buffer[pixelOffset];
        totalGreen += buffer[pixelOffset + 1];
        totalBlue += buffer[pixelOffset + 2];
        // totalAlpha += buffer[pixelOffset + 3];
      }
    }

    // Average color values
    final averageRed = totalRed ~/ (width * height);
    final averageGreen = totalGreen ~/ (width * height);
    final averageBlue = totalBlue ~/ (width * height);
    // final averageAlpha = totalAlpha / (width * height);

    final Color averageColor = Color.fromRGBO(averageRed, averageGreen, averageBlue, 1);

    return averageColor;
  } 
}