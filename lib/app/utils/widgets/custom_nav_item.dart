import 'package:flutter/material.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';

class CustomNavTile extends StatelessWidget {
  final String title;
  final bool selected;
  final IconData icon;
  final void Function() onTap;

  const CustomNavTile(
      {required this.title,
      required this.icon,
      required this.selected,
      required this.onTap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
          border: Border.all(
            color:
                !selected ? ColorHelper.primaryColor : ColorHelper.whiteColor,
          ),
          color: selected ? ColorHelper.primaryColor : ColorHelper.whiteColor,
          borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        selected: selected,
        leading: Icon(icon, color: ColorHelper.blackColor.withAlpha(130)),
        title: Center(
          child: Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: ColorHelper.blackColor.withAlpha(130))),
        ),
        horizontalTitleGap: 0,
        onTap: onTap,
      ),
    );
  }
}
