import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_codes/country_codes.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../GlobalWidgets/button_widget.dart';
import '../../GlobalWidgets/text_field_widget.dart';
import '../../Utilities/app_colors.dart';
import '../../Utilities/app_text_styles.dart';
import '../../Utilities/validator.dart';

class EnrollAsStarScreen extends StatefulWidget {
  const EnrollAsStarScreen({super.key});

  @override
  State<EnrollAsStarScreen> createState() => _EnrollAsStarScreenState();
}

class _EnrollAsStarScreenState extends State<EnrollAsStarScreen> {
  bool agreed = false;
  String? countryCode;
  var countryEmoji = "";
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var socialMediaAccountController = TextEditingController();
  var phoneNumberController = TextEditingController();
  String selectedValue = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getCountryCode();
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  getCountryCode() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await CountryCodes.init();
      final CountryDetails details = CountryCodes.detailsForLocale();
      setState(() {
        countryCode = details.dialCode;
        if (kDebugMode) {
          print(countryCode);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: purpleGradient,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    "assets/logo.png",
                    scale: 1,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 20,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Center(
                    child: Text(
                      "Enroll as Star",
                      style: thirtyFour800TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    hintText: "Your Name",
                    obscureText: false,
                    labelText: "Name",
                    textFieldController: nameController,
                    validator: Validator.validateTextField,
                    isEnrollAsStar: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFieldWidget(
                    hintText: "Enter your Email",
                    labelText: "Email",
                    obscureText: false,
                    isEnrollAsStar: true,
                    textFieldController: emailController,
                    validator: Validator.emailValidator,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Category",
                    style: eighteen600TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 55,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: DropdownButton<String>(
                      hint: Text(
                        "Select Category",
                        style: sixteen500TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      isExpanded: true,
                      dropdownColor: darkPurpleColor,
                      value: selectedValue.isNotEmpty ? selectedValue : null,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ), // Arrow icon
                      iconSize: 24,
                      elevation: 16,
                      style: sixteen400TextStyle(
                        color: Colors.white,
                      ),
                      underline: Container(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                      items: <String>[
                        "Creators",
                        "Comedians",
                        "Music",
                        "Actors",
                        "Mentors",
                        "Anchors",
                        "Sports",
                        "TikTok",
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFieldWidget(
                    hintText: "Add social account",
                    labelText: "Social Media Account",
                    isEnrollAsStar: true,
                    obscureText: false,
                    textFieldController: socialMediaAccountController,
                    validator: Validator.validateTextField,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFieldWidget(
                    isEnrollAsStar: true,
                    hintText: "at least 10 character",
                    maxCharacters: 10,
                    obscureText: false,
                    textFieldController: phoneNumberController,
                    validator: Validator.validateTextField,
                    prefixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              countryEmoji,
                              style: twentyTwo400TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                showCountryPicker(
                                  context: context,
                                  showPhoneCode: true,
                                  onSelect: (Country country) {
                                    countryCode = "+${country.phoneCode}";
                                    countryEmoji = country.flagEmoji;
                                    setState(() {});
                                  },
                                );
                              },
                              child: Text(
                                countryCode ?? "+92",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                    labelText: "Mobile Number",
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          agreed = !agreed;
                          setState(() {});
                        },
                        child: Container(
                          width: 23,
                          height: 23,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: agreed ? Colors.transparent : Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                            color: !agreed ? Colors.transparent : Colors.white,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.check,
                              size: 20,
                              color: !agreed ? Colors.transparent : purpleColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "By signing up, I agree with ",
                                style: sixteen700TextStyle(color: Colors.white),
                              ),
                              TextSpan(
                                text: "Terms of use",
                                style: sixteen700UnderlineTextStyle(
                                    color: Colors.white),
                              ),
                              TextSpan(
                                text: " and ",
                                style: sixteen700TextStyle(color: Colors.white),
                              ),
                              TextSpan(
                                text: "Privacy Policy",
                                style: sixteen700UnderlineTextStyle(
                                    color: Colors.white),
                              ),
                              TextSpan(
                                text: ".",
                                style: sixteen700TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BigButton(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 55,
                    color: Colors.white,
                    text: "Submit",
                    onTap: () {
                      if (!formKey.currentState!.validate()) return;
                      formKey.currentState!.save();
                      if (selectedValue != "") {
                        sendRequest();
                      } else {
                        EasyLoading.showError("Please select Category");
                      }
                    },
                    textStyle: twentyTwo700TextStyle(color: purpleColor),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  sendRequest() async {
    EasyLoading.show(status: "Loading...\nPlease Wait");
    await FirebaseFirestore.instance.collection("enrollAsStarRequests").add({
      "name": nameController.text,
      "email": emailController.text,
      "category": selectedValue,
      "socialMediaAccount": socialMediaAccountController.text,
      "phoneNumber": countryCode.toString() + phoneNumberController.text,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "status": "Active",
    }).then((value) {
      EasyLoading.dismiss();
      enrollConfirmationPopUp();
    });
    EasyLoading.dismiss();
  }

  enrollConfirmationPopUp() {
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
                height: 260,
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
                        "Thank you! Your information has been successfully sent. We will contact you very soon!",
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
                        text: "Done",
                        onTap: () {
                          nameController.clear();
                          emailController.clear();
                          socialMediaAccountController.clear();
                          phoneNumberController.clear();
                          selectedValue = "";
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
