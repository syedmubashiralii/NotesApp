import 'package:flutter/cupertino.dart';

import '../../../utils/utils.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final void Function(bool)? onChanged;

  const CustomSwitch({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
        activeColor: ColorHelper.teal.withAlpha(150),
        thumbColor: ColorHelper.primaryColor,
        value: value,
        onChanged: onChanged);
  }
}
