// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:starsmeetupuser/Apis/authentication_apis.dart';

import '../../Apis/auth_controller.dart';
import '../../Apis/user_apis.dart';
import '../../GlobalWidgets/button_widget.dart';
import '../../GlobalWidgets/text_field_widget.dart';
import '../../LocalStorage/shared_preferences.dart';
import '../../Utilities/app_colors.dart';
import '../../Utilities/app_routes.dart';
import '../../Utilities/app_text_styles.dart';
import '../../Utilities/validator.dart';
import '../../models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool obscureText = true;
  final GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    log("FCM Token:");
    getFCMToken();
    setState(() {});
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  Future<void> getFCMToken() async {
    // Request permission
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get the token
      String? token = await FirebaseMessaging.instance.getToken();
      log("FCM Token: $token");

      MyPreferences.instance.setToken(token: token);
    } else {
      log('User declined or has not yet granted permission.');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                ),
                Image.asset(
                  "assets/logo.png",
                  scale: 3,
                  color: purpleColor,
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Log",
                      style: thirtyTwo700TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "in",
                      style: thirtyTwo700TextStyle(
                        color: purpleColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFieldWidget(
                  formKey: emailKey,
                  hintText: "Enter Your Email",
                  labelText: "Email",
                  obscureText: false,
                  textFieldController: emailController,
                  validator: Validator.emailValidator,
                  onChanged: (value) {
                    // Update the form's state here
                    emailKey.currentState?.validate();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFieldWidget(
                  hintText: "Enter Your Password",
                  textFieldController: passwordController,
                  formKey: passwordKey,
                  validator: Validator.passwordValidator,
                  obscureText: obscureText,
                  suffixIcon: GestureDetector(
                      onTap: () {
                        obscureText = !obscureText;
                        setState(() {});
                      },
                      child: Icon(
                        obscureText == true
                            ? CupertinoIcons.eye
                            : CupertinoIcons.eye_slash,
                        color: Colors.black,
                        size: 25,
                      )),
                  labelText: "Password",
                  onChanged: (value) {
                    // Update the form's state here
                    formKey.currentState?.validate();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            rememberMe = !rememberMe;
                            setState(() {});
                          },
                          child: Container(
                            width: 23,
                            height: 23,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: rememberMe
                                    ? Colors.transparent
                                    : Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                              color: !rememberMe
                                  ? Colors.transparent
                                  : Colors.black,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                size: 20,
                                color: !rememberMe
                                    ? Colors.transparent
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Remember Me",
                          style: fourteen600TextStyle(color: purpleColor),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, forgotPasswordScreenRoute);
                      },
                      child: Text(
                        "Forgot Password?",
                        style: fourteen400TextStyle(color: purpleColor),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                BigButton(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 55,
                  color: purpleColor,
                  text: "Login",
                  onTap: () {
                    onTapSignIn();
                  },
                  textStyle: twentyTwo700TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an Account? ",
                      style: eighteen500TextStyle(color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, signUpScreenRoute);
                      },
                      child: Text(
                        "Sign up",
                        style: eighteen700TextStyle(color: purpleColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onTapSignIn() async {
    if (!emailKey.currentState!.validate()) return;
    if (!passwordKey.currentState!.validate()) return;
    formKey.currentState!.save();
    if (kDebugMode) {
      print(emailController.text.trim().toLowerCase());
    }
    EasyLoading.show(status: "Loading...\nPlease Wait");
    await AuthenticationService()
        .getUser(emailController.text.trim().toLowerCase())
        .then((value) async {
      final token = MyPreferences.instance.getToken();
      if (value["token"] == token) {
        log("token get successfully");
        await Authentication()
            .signIn(
                email: emailController.text.trim().toLowerCase(),
                password: passwordController.text.toString())
            .then((result) async {
          // log("this is result|: ${result!.displayName}");
          if (result == null) {
            EasyLoading.dismiss();

            UserModel? user = await UserService()
                .getUser(emailController.text.trim().toLowerCase());
            if (user != null) {
              MyPreferences.instance.setUser(user: user);
              EasyLoading.showSuccess("Log In Successful");
              Navigator.pushNamedAndRemoveUntil(
                  context, homeScreenRoute, (route) => true,
                  arguments: true);
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
          } else {
            if (kDebugMode) {
              print('User does not exist.');
            }
            EasyLoading.dismiss();
          }
        });
      } else if (token == null) {
        getFCMToken();
      } else {
        EasyLoading.showSuccess("You are Already Login another Device");
      }
    });
  }
}
