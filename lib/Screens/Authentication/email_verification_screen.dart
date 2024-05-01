// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:starsmeetupuser/Utilities/app_routes.dart';
import 'package:starsmeetupuser/Utilities/app_text_styles.dart';

import '../../Apis/auth_controller.dart';
import '../../GlobalWidgets/button_widget.dart';
import '../../Utilities/app_colors.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      EasyLoading.showSuccess("Email Successfully Verified");

      timer?.cancel();
      Navigator.pushNamedAndRemoveUntil(
          context, loginScreenRoute, (route) => false);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Center(
                child: Text(
                  'Check your Email',
                  textAlign: TextAlign.center,
                  style: twenty600TextStyle(),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    'We have sent you an Email on ${Authentication().user?.email}\nPlease click on the link to verify your email',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 60),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    'Verifying email....',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 57),
              Center(
                child: BigButton(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  color: purpleColor,
                  text: "Resend Email",
                  onTap: () {
                    try {
                      FirebaseAuth.instance.currentUser
                          ?.sendEmailVerification();
                    } catch (e) {
                      debugPrint('$e');
                    }
                  },
                  borderRadius: 5.0,
                  textStyle: eighteen700TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 27),
              Center(
                child: BigButton(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  color: purpleColor,
                  text: "Cancel",
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, loginScreenRoute, (route) => false);
                  },
                  borderRadius: 5.0,
                  textStyle: eighteen700TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
