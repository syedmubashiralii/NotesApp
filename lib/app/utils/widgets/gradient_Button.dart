import 'package:flutter/material.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';
import 'package:notes_final_version/app/utils/constants.dart';

class GradientButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final double width;
  final VoidCallback? onPress;

  const GradientButton(
      {this.text = "",
      this.width = double.infinity,
      this.icon,
      this.onPress,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        // shape: const StadiumBorder(),
        borderRadius: BorderRadius.all(
          Radius.circular(AppConstants.kInputBorderRadius),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorHelper.primaryColor,
            ColorHelper.primaryColor.withOpacity(.4)
          ],
        ),
      ),
      child: MaterialButton(
          padding: const EdgeInsets.only(left: 30, right: 25),
          // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // shape: StadiumBorder(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppConstants.kInputBorderRadius),
            ),
          ),
          onPressed: onPress,
          child: Row(
            mainAxisAlignment: text == "" || icon == null
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            children: [
              // .SpaceX,
              text == ""
                  ? const SizedBox.shrink()
                  : Text(
                      '$text',
                      style: MyTextStyle.mediumBlack,
                    ),
              icon == null
                  ? const SizedBox.shrink()
                  : Icon(
                      icon,
                      color: ColorHelper.whiteColor,
                      size: 15,
                    ),
              // 24.SpaceX
            ],
          )),
    );
  }
}
