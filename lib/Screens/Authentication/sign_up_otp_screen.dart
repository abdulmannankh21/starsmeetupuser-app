// // ignore_for_file: prefer_typing_uninitialized_variables
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:pinput/pinput.dart';
//
// import '../../Apis/auth_controller.dart';
// import '../../Apis/authentication_apis.dart';
// import '../../GlobalWidgets/button_widget.dart';
// import '../../Utilities/app_colors.dart';
// import '../../Utilities/app_routes.dart';
// import '../../Utilities/app_text_styles.dart';
// import '../../models/user_model.dart';
//
// class SignUpOtpScreen extends StatefulWidget {
//   final userModel;
//   const SignUpOtpScreen(this.userModel, {super.key});
//
//   @override
//   State<SignUpOtpScreen> createState() => _SignUpOtpScreenState();
// }
//
// class _SignUpOtpScreenState extends State<SignUpOtpScreen> {
//   late UserModel userModel;
//   final formKey = GlobalKey<FormState>();
//   var otpController = TextEditingController();
//   @override
//   void initState() {
//     userModel = widget.userModel;
//     if (kDebugMode) {
//       print(userModel.phoneNumber.toString());
//     }
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Form(
//         key: formKey,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 50,
//                   width: MediaQuery.of(context).size.width,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Icon(
//                         Icons.arrow_back_ios,
//                         color: Colors.grey,
//                         size: 20,
//                       ),
//                     ),
//                     Text(
//                       "Forgot Password",
//                       style: twentyTwo700TextStyle(color: purpleColor),
//                     ),
//                     const SizedBox(
//                       width: 20,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 40,
//                 ),
//                 Text(
//                   "Verification code sent to your phone number ${userModel.phoneNumber}",
//                   style: sixteen500TextStyle(color: Colors.black),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   child: Pinput(
//                     controller: otpController,
//                     onCompleted: (val) {},
//                     length: 6,
//                     defaultPinTheme: PinTheme(
//                       width: 50,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: Colors.grey,
//                         ),
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Didn't you receive any code? ",
//                       style: fourteen400TextStyle(color: Colors.black),
//                       textAlign: TextAlign.center,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         verifyPhone();
//                       },
//                       child: Text(
//                         "RESEND NEW CODE",
//                         style: fourteen600TextStyle(color: purpleColor),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 BigButton(
//                   width: MediaQuery.of(context).size.width * 0.9,
//                   height: 55,
//                   color: purpleColor,
//                   text: "Verify",
//                   onTap: () async {
//                     try {
//                       EasyLoading.show(status: "Loading...\nPlease Wait");
//                       PhoneAuthCredential phoneAuthCredentials =
//                           PhoneAuthProvider.credential(
//                               verificationId:
//                                   userModel.phoneVerificationId.toString(),
//                               smsCode: otpController.text);
//
//                       final authResult = await FirebaseAuth.instance
//                           .signInWithCredential(phoneAuthCredentials);
//
//                       if (authResult.user != null) {
//                         Authentication()
//                             .signUp(
//                                 email: userModel.email,
//                                 password: userModel.password)
//                             .then((result) async {
//                           if (result == null) {
//                             AuthenticationService().uploadUser(
//                               UserModel(
//                                 name: userModel.name,
//                                 status: "Active",
//                                 createdAt:
//                                     DateTime.now().millisecondsSinceEpoch,
//                                 backgroundPicture: null,
//                                 email: userModel.email,
//                                 type: "User",
//                                 password: userModel.password,
//                                 phoneNumber: userModel.phoneNumber,
//                                 profilePicture: null,
//                                 updatedAt: null,
//                                 phoneVerificationId:
//                                     userModel.phoneVerificationId,
//                                 userID: userModel.email,
//                               ),
//                             );
//                             EasyLoading.showSuccess("Sign Up Successful");
//                             Navigator.pushNamedAndRemoveUntil(
//                                 context, loginScreenRoute, (route) => false);
//                           }
//                         });
//                       } else {
//                         Fluttertoast.showToast(
//                             msg: "Wrong Verification Code",
//                             toastLength: Toast.LENGTH_LONG,
//                             gravity: ToastGravity.BOTTOM,
//                             timeInSecForIosWeb: 2,
//                             backgroundColor: Colors.red,
//                             textColor: Colors.white,
//                             fontSize: 16.0);
//                       }
//                     } catch (error) {
//                       Fluttertoast.showToast(
//                           msg: "Error: $error",
//                           toastLength: Toast.LENGTH_LONG,
//                           gravity: ToastGravity.BOTTOM,
//                           timeInSecForIosWeb: 2,
//                           backgroundColor: Colors.red,
//                           textColor: Colors.white,
//                           fontSize: 16.0);
//                     }
//                     EasyLoading.dismiss();
//                   },
//                   textStyle: twentyTwo700TextStyle(color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   resetPasswordEmailPopUp() {
//     showGeneralDialog(
//       context: context,
//       barrierLabel: "Barrier",
//       transitionDuration: const Duration(seconds: 0),
//       barrierDismissible: false,
//       pageBuilder: (_, __, ___) {
//         return Center(
//           child: Material(
//             color: Colors.transparent,
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 20),
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 color: Colors.white,
//               ),
//               padding: const EdgeInsets.all(10.0),
//               child: SizedBox(
//                 height: 280,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Container(
//                       width: 60,
//                       height: 60,
//                       decoration: const BoxDecoration(
//                         color: greenColor,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Center(
//                         child: Icon(
//                           Icons.check,
//                           size: 25,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: Text(
//                         "Reset email has been sent successfully! Please check your email to reset your password",
//                         style: eighteen600TextStyle(color: Colors.black),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Center(
//                       child: BigButton(
//                         width: MediaQuery.of(context).size.width * 0.7,
//                         height: 50,
//                         color: purpleColor,
//                         text: "Done",
//                         onTap: () {
//                           Navigator.pushNamedAndRemoveUntil(
//                               context, loginScreenRoute, (route) => false);
//                         },
//                         borderRadius: 5.0,
//                         textStyle: eighteen700TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> verifyPhone() async {
//     if (!formKey.currentState!.validate()) return;
//     formKey.currentState!.save();
//     EasyLoading.show(status: "Loading...\nPlease Wait");
//     verified(AuthCredential authResult) {
//       if (kDebugMode) {
//         print(authResult.token.toString());
//       }
//     }
//
//     verificationFailed(FirebaseAuthException authException) {
//       EasyLoading.dismiss();
//       if (kDebugMode) {
//         print('Error ${authException.message}');
//       }
//       Fluttertoast.showToast(
//           msg: authException.message.toString(),
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 2,
//           backgroundColor: redColor,
//           textColor: Colors.white,
//           fontSize: 16.0);
//     }
//
//     smsSent(String verId, [int? forceRecord]) {
//       EasyLoading.dismiss();
//       userModel.phoneVerificationId = verId;
//
//       EasyLoading.showSuccess("Otp Sent Again!");
//     }
//
//     autoTimeout(String verId) {
//       userModel.phoneVerificationId = verId;
//       EasyLoading.dismiss();
//     }
//
//     await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: userModel.phoneNumber,
//         timeout: const Duration(minutes: 2),
//         verificationCompleted: verified,
//         verificationFailed: verificationFailed,
//         codeSent: smsSent,
//         codeAutoRetrievalTimeout: autoTimeout);
//   }
// }
