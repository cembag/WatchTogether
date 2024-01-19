import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension ColorExtension on Color {
  Color changeColor({ChangeColor changeColor = ChangeColor.add, int all = 0, int r = 0, int g = 0, int b = 0}) {
    if(all != 0) {
      r = all;
      g = all;
      b = all;
    }
    switch(changeColor) {
      case ChangeColor.add:
        final redColor = r < 0 ? (red + r) >= 0 ? (red + r) : 0 : (red + r) <= 255 ? (red + r) : 255; 
        final greenColor = g < 0 ? (green + g) >= 0 ? (green + g) : 0 : (green + g) <= 255 ? (green + g) : 255; 
        final blueColor = b < 0 ? (blue + b) >= 0 ? (blue + b) : 0 : (blue + b) <= 255 ? (blue + b) : 255; 
        return Color.fromRGBO(redColor, greenColor, blueColor, opacity);
      case ChangeColor.divide:
        final redColor = r == 0 ? red : (red ~/ r).abs();
        final greenColor = g == 0 ? green : (green ~/ g).abs();
        final blueColor = b == 0 ? blue : (blue ~/ b).abs();
        return Color.fromRGBO(redColor, greenColor, blueColor, opacity);
      default:
        return this;
    }
  }

  Color moveCloserToColor(Color color, {MoveColor moveColor = MoveColor.factor, int value = 10, double moveFactor = 2}) {
    if(moveFactor <= 1) {
      moveFactor = 1;
    }
    switch(moveColor) {
      case MoveColor.factor:
        final redColor = (color.red < red) ? red - ((red - color.red) * (1 - 1/moveFactor)).toInt() : red + ((color.red - red) * (1 - 1/moveFactor)).toInt();
        final greenColor = (color.green < green) ? green - ((green - color.green) * (1 - 1/moveFactor)).toInt() : green + ((color.green - green) * (1 - 1/moveFactor)).toInt();
        final blueColor = (color.blue < blue) ? blue - ((blue - color.blue) * (1 - 1/moveFactor)).toInt() : blue + ((color.blue - blue) * (1 - 1/moveFactor)).toInt();
        final opacityValue = (color.opacity < opacity) ? opacity - (opacity - color.opacity) * (1 - 1/moveFactor) : opacity + (color.opacity - opacity) * (1 - 1/moveFactor);
        printInfo(info: "MAIN_COLOR: $red $green $blue, CLOSER_COLOR: ${color.red}, ${color.green} ${color.blue}, FINAL_COLOR: $redColor $greenColor $blueColor");
        return Color.fromRGBO(redColor, greenColor, blueColor, opacityValue);
      case MoveColor.value:
        final redColor = (color.red < red) ? (color.red + value >= red ? red : red - value) : (color.red - value) <= red ? red : (red + value);
        final greenColor = (color.green < green) ? (color.green + value >= green ? green : green - value) : (color.green - value) <= green ? green : (green + value);
        final blueColor = (color.blue < blue) ? (color.blue + value >= blue ? blue : blue - value) : (color.blue - value) <= blue ? blue : (blue + value);
        printInfo(info: "MAIN_COLOR: $red $green $blue, CLOSER_COLOR: ${color.red}, ${color.green} ${color.blue}, FINAL_COLOR: $redColor $greenColor $blueColor");
        return Color.fromRGBO(redColor, greenColor, blueColor, opacity);
      default:
        return this;
    }
  }

  // Returns true if the color's brightness is lower than a defined threshold.
  bool get isCloseToBlack {
    // Calculate the color's brightness
    final brightness = (0.299 * red + 0.587 * green + 0.114 * blue).round();
    // Check if the brightness is lower than the threshold.
    return brightness < brightnessTreshold;
  }

  bool get isAlmostDark {
    // Calculate the color's brightness
    final brightness = (0.299 * red + 0.587 * green + 0.114 * blue).round();
    // Check if the brightness is lower than the threshold.
    return brightness < brightnessDarkTreshold;
  }
}

const brightnessTreshold = 64;
const brightnessDarkTreshold = 24;

enum ChangeColor {
  add,
  divide
}

enum MoveColor {
  value,
  factor
}