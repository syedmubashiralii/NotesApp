import 'package:flutter/material.dart';

extension SpaceXY on int {
  SizedBox get SpaceX => SizedBox(
        height: toDouble(),
      );

  SizedBox get SpaceY => SizedBox(
        width: toDouble(),
      );
}
