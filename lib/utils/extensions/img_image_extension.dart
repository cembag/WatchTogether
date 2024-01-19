import 'dart:ui';
import 'package:image/image.dart' as img;

extension IMGImageExtension on img.Image {

  Color get averageColor {

    final pixelCount = width * height;
    int totalRed = 0;
    int totalGreen = 0;
    int totalBlue = 0;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final c = getPixel(x, y);
        totalRed += c.r.toInt();
        totalGreen += c.g.toInt();
        totalBlue += c.b.toInt();
      }
    }

    final averageRed = totalRed ~/ pixelCount;
    final averageGreen = totalGreen ~/ pixelCount;
    final averageBlue = totalBlue ~/ pixelCount;

    Color averageColor = Color.fromRGBO(averageRed, averageGreen, averageBlue, 1);
    return averageColor;
  }
}