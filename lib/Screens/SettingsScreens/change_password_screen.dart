import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:starsmeetupuser/Utilities/validator.dart';

import '../../Apis/user_apis.dart';
import '../../GlobalWidgets/button_widget.dart';
import '../../GlobalWidgets/text_field_dark_widget.dart';
import '../../LocalStorage/shared_preferences.dart';
import '../../Utilities/app_colors.dart';
import '../../Utilities/app_text_styles.dart';
import '../../models/user_model.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var newPasswordController2 = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> oldPassKey = GlobalKey<FormState>();
  final GlobalKey<FormState> newPassKey = GlobalKey<FormState>();
  final GlobalKey<FormState> conNewPassKey = GlobalKey<FormState>();
  bool agreed = false;
  bool obscureText1 = true;
  bool obscureText2 = true;
  bool obscureText3 = true;
  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: Padding(
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
                "Change Password",
                style: twentyTwo600TextStyle(color: purpleColor),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldDarkWidget(
                key: oldPassKey,
                hintText: "Enter Old Password",
                labelText: "Old Password",
                validator: Validator.validateTextField,
                textFieldController: oldPasswordController,
                onChanged: (value) {
                  // Update the form's state here
                  oldPassKey.currentState?.validate();
                },
                suffixIcon: GestureDetector(
                  onTap: () {
                    obscureText1 = !obscureText1;
                    setState(() {});
                  },
                  child: Icon(
                    obscureText1 == true
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash,
                    color: Colors.black,
                    size: 25,
                  ),
                ),
                obscure: obscureText1,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldDarkWidget(
                key: newPassKey,
                hintText: "Enter New Password",
                suffixIcon: GestureDetector(
                  onTap: () {
                    obscureText2 = !obscureText2;
                    setState(() {});
                  },
                  child: Icon(
                    obscureText2 == true
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash,
                    color: Colors.black,
                    size: 25,
                  ),
                ),
                labelText: "New Password",
                obscure: obscureText2,
                validator: Validator.passwordValidator,
                textFieldController: newPasswordController,
                onChanged: (value) {
                  // Update the form's state here
                  newPassKey.currentState?.validate();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldDarkWidget(
                key: conNewPassKey,
                hintText: "Enter Confirm Password",
                suffixIcon: GestureDetector(
                  onTap: () {
                    obscureText3 = !obscureText3;
                    setState(() {});
                  },
                  child: Icon(
                    obscureText3 == true
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash,
                    color: Colors.black,
                    size: 25,
                  ),
                ),
                obscure: obscureText3,
                labelText: "Confirm Password",
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Confirm Password field is required';
                  } else if (val != newPasswordController.text) {
                    return "It doesn't match with the password";
                  }
                  return null;
                },
                onChanged: (value) {
                  // Update the form's state here
                  conNewPassKey.currentState?.validate();
                },
                textFieldController: newPasswordController2,
              ),
              const SizedBox(
                height: 40,
              ),
              BigButton(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 55,
                color: purpleColor,
                text: "Update",
                onTap: () async {
                  if (!formKey.currentState!.validate()) return;
                  formKey.currentState!.save();
                  EasyLoading.show(status: "Loading...");

                  try {
                    final AuthCredential credential =
                        EmailAuthProvider.credential(
                      email: MyPreferences.instance.user!.email.toString(),
                      password: oldPasswordController.text,
                    );

                    final User user = FirebaseAuth.instance.currentUser!;
                    await user
                        .reauthenticateWithCredential(credential)
                        .then((value) async {
                      await user.updatePassword(newPasswordController.text);

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(MyPreferences.instance.user!.email.toString())
                          .update({
                        'Password': newPasswordController.text,
                      });

                      UserModel? user2 = await UserService().getUser(
                          MyPreferences.instance.user!.userID.toString());
                      if (user2 != null) {
                        MyPreferences.instance.setUser(user: user2);
                      } else {
                        Fluttertoast.showToast(
                            msg: "Something went wrong!",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            backgroundColor: redColor,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                      changePasswordEmailPopUp();
                    }).onError((error, stackTrace) {
                      EasyLoading.showError("Incorrect Password");
                    });
                  } on FirebaseAuthException catch (e) {
                    print("Firebase error code: ${e.code}"); // Debug statement
                    String errorMessage = _getFirebaseAuthErrorMessage(e.code);
                    EasyLoading.showError(errorMessage);
                  }

                  EasyLoading.dismiss();
                },
                textStyle: twentyTwo700TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case "invalid-email":
        return "Invalid email format. Please enter a valid email.";
      case "user-not-found":
        return "User not found";
      case "wrong-password":
        return "Invalid email or password. Please try again.";
      case "too-many-requests":
        return "Too many unsuccessful attempts. Please try again later.";
      case "invalid-credential":
        return "Invalid email or password. Please try again.";
      default:
        return "An error occurred(User might not exist). Please try again.";
    }
  }

  changePasswordEmailPopUp() {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      transitionDuration: const Duration(seconds: 0),
      barrierDismissible: true,
      pageBuilder: (_, __, ___) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 240,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: greenColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Your password has been changed successfully!",
                        style: eighteen600TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: BigButton(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 50,
                        color: purpleColor,
                        text: "Continue",
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        borderRadius: 5.0,
                        textStyle: eighteen700TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
