import 'package:flutter/material.dart';

Text labelText(
  String label, {
  Color? color,
  TextAlign? textAlign,
  double? fontSize,
  FontWeight? fontWeight,
  TextOverflow? overflow,
  double? letterSpacing,
  TextDecoration textDecoration = TextDecoration.none,
  double height = 1.2,
}) {
  return Text(
    label,
    textScaleFactor: 1.0,
    textAlign: textAlign,
    overflow: overflow,
    softWrap: true,
    style: TextStyle(
      color: color ?? Colors.black,
      fontWeight: fontWeight ?? FontWeight.w600,
      fontSize: fontSize ?? 16,
      letterSpacing: letterSpacing,
      decoration: textDecoration,
      height: height,
    ),
  );
} 

Text subtext(
  String label, {
  Color? color,
  TextAlign? textAlign,
  FontWeight? fontWeight,
  TextDecoration? textDecoration,
  double? fontSize,
  int? maxLines,
  TextOverflow? overflow,
  double height = 1.2,
}) {
  return Text(
    label,
    textScaleFactor: 1.0,
    textAlign: textAlign,
    softWrap: true,
    overflow: overflow,
    maxLines: maxLines,
    style: TextStyle(
      color: color ?? Colors.black,
      fontSize: fontSize ?? 15,
      fontWeight: fontWeight ?? FontWeight.w400,
      decoration: textDecoration,
      height: height,
    ),
  );
}
