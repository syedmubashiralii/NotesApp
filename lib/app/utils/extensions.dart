import 'package:flutter/material.dart';

extension SpaceXY on int {
  SizedBox get spaceY => SizedBox(
        height: toDouble(),
      );

  SizedBox get spaceX => SizedBox(
        width: toDouble(),
      );
}
