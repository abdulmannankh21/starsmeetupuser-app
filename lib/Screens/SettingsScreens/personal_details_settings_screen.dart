// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:starsmeetupuser/LocalStorage/shared_preferences.dart';

import '../../Apis/user_apis.dart';
import '../../GlobalWidgets/button_widget.dart';
import '../../GlobalWidgets/text_field_dark_widget.dart';
import '../../Utilities/app_colors.dart';
import '../../Utilities/app_text_styles.dart';
import '../../Utilities/validator.dart';

class PersonalDetailsSettingsScreen extends StatefulWidget {
  const PersonalDetailsSettingsScreen({super.key});

  @override
  State<PersonalDetailsSettingsScreen> createState() =>
      _PersonalDetailsSettingsScreenState();
}

class _PersonalDetailsSettingsScreenState
    extends State<PersonalDetailsSettingsScreen> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneNumberController = TextEditingController();
  @override
  void initState() {
    getAllInfo();
    super.initState();
  }

  getAllInfo() {
    nameController.text = MyPreferences.instance.user!.name!;
    emailController.text = MyPreferences.instance.user!.email!;
    phoneNumberController.text = MyPreferences.instance.user!.phoneNumber!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              height: 20,
            ),
            Text(
              "Personal Details",
              style: twentyTwo600TextStyle(color: purpleColor),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFieldDarkWidget(
              hintText: "Your Name",
              labelText: "Name",
              textFieldController: nameController,
              validator: Validator.validateTextField,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFieldDarkWidget(
              hintText: "Enter Your Email",
              labelText: "Email",
              textFieldController: emailController,
              validator: Validator.validateTextField,
              readOnly: true,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFieldDarkWidget(
              hintText: "+923009876543",
              labelText: "Phone Number",
              readOnly: true,
              textFieldController: phoneNumberController,
              validator: Validator.validateTextField,
            ),
            const SizedBox(
              height: 40,
            ),
            BigButton(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 55,
              color: purpleColor,
              text: "Save",
              onTap: () async {
                if (nameController.text != "") {
                  await UserService().updateUserName(
                      MyPreferences.instance.user!.userID.toString(),
                      nameController.text);
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
              },
              textStyle: twentyTwo700TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
