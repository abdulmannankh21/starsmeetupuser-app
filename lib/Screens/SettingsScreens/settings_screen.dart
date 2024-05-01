import 'package:flutter/material.dart';

import '../../GlobalWidgets/settings_widget.dart';
import '../../Utilities/app_colors.dart';
import '../../Utilities/app_routes.dart';
import '../../Utilities/app_text_styles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
                Text(
                  "Settings",
                  style: twentyTwo700TextStyle(color: purpleColor),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            SettingsWidget(
              onTap: () {
                Navigator.pushNamed(
                    context, personalDetailsSettingsScreenRoute);
              },
              image: "assets/profileIcon.png",
              imageColor: purpleColor,
              text: "Personal Details",
            ),
            SettingsWidget(
              onTap: () {
                Navigator.pushNamed(context, changePasswordScreenRoute);
              },
              image: "assets/padlockIcon.png",
              imageColor: purpleColor,
              text: "Change Password",
            ),
            SettingsWidget(
              onTap: () {
                Navigator.pushNamed(context, privacyPolicyScreenRoute);
              },
              image: "assets/privacyPolicyIcon.png",
              text: "Privacy Policy",
              imageColor: purpleColor,
            ),
            SettingsWidget(
              onTap: () {
                Navigator.pushNamed(context, termsOfUseScreenRoute);
              },
              image: "assets/termsAndConditionsIcon.png",
              text: "Terms of use",
              imageColor: purpleColor,
            ),
            SettingsWidget(
              onTap: () {
                Navigator.pushNamed(context, faqScreenRoute);
              },
              image: "assets/infoIcon.png",
              text: "FAQs",
              imageColor: purpleColor,
            ),
          ],
        ),
      ),
    );
  }
}
