import 'package:flutter/material.dart';

import '../controllers/signup_controller.dart';

List<Widget> getPasswordCheckWidgets(PasswordCheckController controller,
    {bool fromSecurityScreen = false}) {
  List<Widget> widgets = [];

  for (int i = 0; i < controller.lineList.length; i++) {
    String line = controller.lineList[i];
    bool check = fromSecurityScreen
        ? controller.securityKeyChecks[i]
        : controller.passwordChecks[i];
    widgets.add(
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.check_circle,
              size: 16,
              color: check ? const Color(0XFF22871F) : const Color(0XFF999999),
            ),
            const SizedBox(width: 8),
            // Add some spacing between the icon and the text
            Flexible(fit: FlexFit.loose, child: Text(line)),
          ],
        ),
      ),
    );
  }
  return widgets;
}
