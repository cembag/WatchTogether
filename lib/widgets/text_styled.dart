

import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

Text textStyled(
  String text, 
  double fontSize, 
  Color color,
  {
    String? fontFamily = "Roboto",
    double? lineHeight,
    List<Shadow>? shadows,
    TextAlign? textAlign = TextAlign.start,
    FontWeight? fontWeight = FontWeight.normal,
    TextDecoration? textDecoration = TextDecoration.none,   
    double? letterSpacing,
    TextOverflow? overflow,
    int? maxLines,
    bool responsive = false,
  }) => Text(
  text,
  textAlign: textAlign,
  overflow: overflow,
  maxLines: maxLines,
  style: TextStyle(
    fontFamily: fontFamily,
    height: lineHeight,
    fontSize: (responsive && Device.get().isTablet) ? fontSize * 1.5 : fontSize,
    fontWeight: fontWeight,
    decoration: textDecoration,
    color: color,
    shadows: shadows,
    letterSpacing: letterSpacing
  )
);