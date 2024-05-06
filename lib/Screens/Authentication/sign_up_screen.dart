import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:starsmeetupuser/LocalStorage/shared_preferences.dart';
import 'package:starsmeetupuser/Utilities/app_routes.dart';

import '../../Apis/auth_controller.dart';
import '../../Apis/authentication_apis.dart';
import '../../GlobalWidgets/button_widget.dart';
import '../../GlobalWidgets/text_field_widget.dart';
import '../../Utilities/app_colors.dart';
import '../../Utilities/app_text_styles.dart';
import '../../Utilities/validator.dart';
import '../../models/user_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> nameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
  final GlobalKey<FormState> confirmPasswordKey = GlobalKey<FormState>();
  final GlobalKey<FormState> phoneNumberKey = GlobalKey<FormState>();
  bool obscureText1 = true;
  bool obscureText2 = true;
  bool agreed = false;

  String countryCode = "+92";
  String countryEmoji = "🇵🇰";

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 70),
              Image.asset(
                "assets/logo.png",
                scale: 3,
                color: purpleColor,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sign ",
                      style: thirtyTwo700TextStyle(color: Colors.black)),
                  Text("up", style: thirtyTwo700TextStyle(color: purpleColor)),
                ],
              ),
              const SizedBox(height: 20),
              buildTextField(
                hintText: "Enter your Name",
                labelText: "Name",
                key: nameKey,
                controller: nameController,
                validator: Validator.validateTextField,
                onChanged: (value) {
                  // Update the form's state here
                  nameKey.currentState?.validate();
                },
              ),
              const SizedBox(height: 20),
              buildTextField(
                hintText: "Enter your Email",
                labelText: "Email",
                key: emailKey,
                controller: emailController,
                validator: Validator.emailValidator,
                onChanged: (value) {
                  // Update the form's state here
                  emailKey.currentState?.validate();
                },
              ),
              const SizedBox(height: 20),
              buildPasswordTextField(
                key: passwordKey,
                hintText: "at least 8 characters",
                labelText: "Password",
                controller: passwordController,
                obscureText: obscureText1,
                onPressed: () => setState(() => obscureText1 = !obscureText1),
                validator: Validator.passwordValidator,
                onChanged: (value) {
                  // Update the form's state here
                  passwordKey.currentState?.validate();
                },
              ),
              const SizedBox(height: 20),
              buildPasswordTextField(
                key: confirmPasswordKey,
                hintText: "at least 8 characters",
                labelText: "Repeat Password",
                controller: confirmPasswordController,
                obscureText: obscureText2,
                onPressed: () => setState(() => obscureText2 = !obscureText2),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Confirm Password field is required';
                  } else if (val != passwordController.text) {
                    return "It doesn't match with the password";
                  }
                  return null;
                },
                onChanged: (value) {
                  // Update the form's state here
                  confirmPasswordKey.currentState?.validate();
                },
              ),
              const SizedBox(height: 20),
              buildPhoneNumberField(),
              const SizedBox(height: 20),
              buildAgreementRow(),
              const SizedBox(height: 20),
              buildSignUpButton(),
              const SizedBox(height: 20),
              buildLoginRow(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String hintText,
    required String labelText,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    required GlobalKey<FormState> key,
    bool obscureText = false,
    void Function(String)? onChanged, // Added onChanged callback
  }) {
    return TextFieldWidget(
      formKey: key,
      hintText: hintText,

      labelText: labelText,
      obscureText: obscureText,
      textFieldController: controller,
      validator: validator,
      onChanged: onChanged, // Pass the onChanged callback to TextFieldWidget
    );
  }

  Widget buildPasswordTextField({
    required String hintText,
    required String labelText,
    required TextEditingController controller,
    required bool obscureText,
    required GlobalKey<FormState> key,
    required VoidCallback onPressed,
    required String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFieldWidget(
      formKey: key,
      hintText: hintText,
      labelText: labelText,
      obscureText: obscureText,
      textFieldController: controller,
      validator: validator,
      onChanged: onChanged,
      suffixIcon: GestureDetector(
        onTap: onPressed,
        child: Icon(
          obscureText ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
          color: Colors.black,
          size: 20,
        ),
      ),
    );
  }

  Widget buildPhoneNumberField() {
    return TextFieldWidget(
      formKey: phoneNumberKey,
      hintText: "Mobile Number",
      maxCharacters: 10,
      obscureText: false,
      onChanged: (val) {
        val = val.replaceAll(' ', '');
        phoneNumberController.text = val;
        phoneNumberKey.currentState?.validate();
        if (val.isNotEmpty && val[0] == '0') {
          phoneNumberController.text = val.substring(1);
        }
      },
      textFieldController: phoneNumberController,
      validator: Validator.validateTextField,
      prefixIcon: buildCountrySelection(),
      labelText: "Mobile Number",
    );
  }

  Widget buildCountrySelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 10),
            Text(countryEmoji, style: TextStyle(color: Colors.white)),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => showCountryPicker(
                context: context,
                showPhoneCode: true,
                onSelect: (Country country) {
                  countryCode = "+${country.phoneCode}";
                  countryEmoji = country.flagEmoji;
                  setState(() {});
                },
              ),
              child: Text(
                countryCode,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ],
    );
  }

  Widget buildAgreementRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => agreed = !agreed),
          child: Container(
            width: 23,
            height: 23,
            decoration: BoxDecoration(
              border: Border.all(
                color: agreed ? Colors.transparent : Colors.black,
              ),
              borderRadius: BorderRadius.circular(5.0),
              color: agreed ? Colors.black : Colors.transparent,
            ),
            child: Center(
              child: Icon(
                Icons.check,
                size: 20,
                color: agreed ? Colors.white : Colors.transparent,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: "By signing up, I agree with ",
                    style: sixteen600TextStyle(color: Colors.black)),
                TextSpan(
                    text: "Terms of use ",
                    style: sixteen600TextStyle(color: purpleColor)),
                TextSpan(
                    text: "and ",
                    style: sixteen600TextStyle(color: Colors.black)),
                TextSpan(
                    text: "Privacy Policy.",
                    style: sixteen600TextStyle(color: purpleColor)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSignUpButton() {
    return BigButton(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 55,
      color: purpleColor,
      text: "Sign up",
      onTap: signUp,
      textStyle: twentyTwo700TextStyle(color: Colors.white),
    );
  }

  Widget buildLoginRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an Account? ",
            style: eighteen500TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, loginScreenRoute),
          child: Text("Login", style: eighteen700TextStyle(color: purpleColor)),
        ),
      ],
    );
  }

  // void signUp() async {
  //   if (!nameKey.currentState!.validate()) return;
  //   if (!emailKey.currentState!.validate()) return;
  //   if (!passwordKey.currentState!.validate()) return;
  //   if (!confirmPasswordKey.currentState!.validate()) return;
  //   if (!phoneNumberKey.currentState!.validate()) return;
  //
  //   if (passwordController.text != confirmPasswordController.text) {
  //     EasyLoading.showError("Password did not match");
  //     return;
  //   }
  //
  //   if (!agreed) {
  //     EasyLoading.showError(
  //         "You must agree to our terms of use and privacy policy");
  //     return;
  //   }
  //
  //   try {
  //     final result = await Authentication().signUp(
  //       email: emailController.text.trim().toLowerCase(),
  //       password: passwordController.text,
  //     );
  //
  //     if (result == null) {
  //       final token = MyPreferences.instance.getToken();
  //       log("this is pref token:${token}");
  //       await AuthenticationService().uploadUser(
  //         UserModel(
  //           name: nameController.text,
  //           status: "Active",
  //           createdAt: DateTime.now().millisecondsSinceEpoch,
  //           backgroundPicture: null,
  //           email: emailController.text.trim().toLowerCase(),
  //           password: passwordController.text,
  //           phoneNumber: countryCode + phoneNumberController.text,
  //           profilePicture: null,
  //           updatedAt: null,
  //           userID: emailController.text.trim().toLowerCase(),
  //           // token: token.toString(),
  //         ),
  //       );
  //
  //       EasyLoading.showSuccess("Sign Up Successful");
  //       Navigator.pushNamedAndRemoveUntil(
  //           context, emailVerificationScreenRoute, (route) => false);
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     EasyLoading.showError(e.toString());
  //   }
  // }
}
