import 'package:flutter/material.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/constants/constants.dart';

class HanddietextBase extends StatelessWidget {
  const HanddietextBase(
    this.text, {
    this.style,
    this.textAlign = TextAlign.left,
    this.overflow = TextOverflow.visible,
    this.maxLines = 1,
    super.key,
  });
  final String? text;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    assert(text != null, 'test can not be null');
    return Text(
      text ?? '',
      style: const TextStyle(
        fontSize: 15,
        fontFamily: AppFonts.manRope,
      ).merge(style),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}

class TextBody extends HanddietextBase {
  TextBody(
    String super.text, {
    super.key,
    TextStyle? style,
    Color? color,
    double? fontSize,
    super.textAlign,
    FontWeight fontWeight = FontWeight.w400,
    super.overflow,
    super.maxLines = 2,
    double? height,
  }) : super(
          style: TextStyle(
            fontSize: fontSize ?? 14,
            color: color ?? AppColors.textPrimaryColor,
            fontWeight: fontWeight,
            height: height,
          ).merge(style),
        );
}

class H1 extends HanddietextBase {
  H1(
    String super.text, {
    super.key,
    Color? color,
    TextStyle? style,
    double? fontSize,
    FontWeight fontWeight = FontWeight.w900,
    super.textAlign,
    super.overflow,
    super.maxLines = 3,
  }) : super(
          style: TextStyle(
            fontSize: fontSize ?? 30,
            fontWeight: fontWeight,
            color: color ?? AppColors.textPrimaryColor,
          ).merge(style),
        );
}

class TextBold extends HanddietextBase {
  TextBold(
    String super.text, {
    super.key,
    TextStyle? style,
    double fontSize = 32,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
    super.textAlign,
    super.overflow,
    super.maxLines = 2,
  }) : super(
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color ?? AppColors.textPrimaryColor,
          ).merge(style),
        );
}

class TextSemiBold extends HanddietextBase {
  TextSemiBold(
    String super.text, {
    super.key,
    TextStyle? style,
    double? fontSize,
    Color? color,
    FontWeight fontWeight = FontWeight.w500,
    super.textAlign,
    super.overflow,
    super.maxLines = 2,
  }) : super(
          style: TextStyle(
            fontSize: fontSize ?? 14,
            color: color ?? AppColors.textPrimaryColor,
            fontWeight: fontWeight,
          ).merge(style),
        );
}

class TextSmall extends HanddietextBase {
  TextSmall(
    String super.text, {
    double fontSize = 12,
    super.key,
    TextStyle? style,
    Color? color,
    super.textAlign,
    super.overflow,
    super.maxLines = 2,
    FontStyle? fontStyle,
    FontWeight fontWeight = FontWeight.w300,
  }) : super(
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            fontStyle: fontStyle,
          ).merge(style),
        );
}
