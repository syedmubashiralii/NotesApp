import 'package:flutter/material.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';

class AppConstants {
  static double kDefaultSpace = 8.0;
  static double kInputBorderRadius = 8;
  static double kScreenPadding = 6.0;
  static double kAppbarFontSize = 20;
}

class MyTextStyle {
  static var medium07Black = TextStyle(
      color: ColorHelper.blackColor.withOpacity(0.7),
      fontFamily: "AlbertSans",
      fontWeight: FontWeight.w500);

  static var normalBlack = TextStyle(
      color: ColorHelper.blackColor.withOpacity(0.7),
      fontWeight: FontWeight.normal);
  static var mediumBlack = const TextStyle(
      color: ColorHelper.blackColor,
      fontFamily: "AlbertSans",
      fontWeight: FontWeight.w500);

  static var white16 = const TextStyle(
      fontSize: 16,
      color: ColorHelper.whiteColor,
      fontFamily: "AlbertSans",
      fontWeight: FontWeight.w600);
}

const String assetImagePath = "assets/images";

class ImageAsset {
  static const String filterIcon = "$assetImagePath/filter.svg";
  static const String notesIcon = '$assetImagePath/icons8-notes.png';
}

class MapKeys {
  static String selectedProductImageList = "selectedProductImageList";
  static String selectedProductId = "selectedProductId";
}