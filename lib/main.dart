import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:starsmeetupuser/video_call_screen_test.dart';

import 'LocalStorage/shared_preferences.dart';
import 'Screens/AppointmentScreens/appointment_screen.dart';
import 'Screens/AppointmentScreens/audio_calling_screen.dart';
import 'Screens/AppointmentScreens/book_calendar_screen.dart';
import 'Screens/AppointmentScreens/cancelled_appointments_screen.dart';
import 'Screens/AppointmentScreens/checkout_screen.dart';
import 'Screens/AppointmentScreens/history_appointment_details_screen.dart';
import 'Screens/AppointmentScreens/video_calling_screen.dart';
import 'Screens/Authentication/email_verification_screen.dart';
import 'Screens/Authentication/forgot_password_screen.dart';
import 'Screens/Authentication/login_screen.dart';
import 'Screens/Authentication/sign_up_screen.dart';
import 'Screens/Authentication/splash_screen.dart';
import 'Screens/HomeScreens/all_actors_in_categories_screen.dart';
import 'Screens/HomeScreens/all_categories_screen.dart';
import 'Screens/HomeScreens/enroll_as_star_screen.dart';
import 'Screens/HomeScreens/favourites_screen.dart';
import 'Screens/HomeScreens/home_screen.dart';
import 'Screens/HomeScreens/notifications_screen.dart';
import 'Screens/HomeScreens/reviews_screen.dart';
import 'Screens/Profiles/celebrity_profile_screen.dart';
import 'Screens/Profiles/profile_screen.dart';
import 'Screens/SettingsScreens/change_password_screen.dart';
import 'Screens/SettingsScreens/faq_screen.dart';
import 'Screens/SettingsScreens/help_screen.dart';
import 'Screens/SettingsScreens/personal_details_settings_screen.dart';
import 'Screens/SettingsScreens/privacy_policy_screen.dart';
import 'Screens/SettingsScreens/settings_screen.dart';
import 'Screens/SettingsScreens/terms_of_use_screen.dart';
import 'Utilities/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await MyPreferences.instance.init();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: splashScreenRoute,
      builder: EasyLoading.init(),
      routes: {
        splashScreenRoute: (context) => const SplashScreen(),
        testVideoCallRoute: (context) => const TestVideoCall(),
        // signUpOtpScreenRoute: (context) {
        //   var i = ModalRoute.of(context)!.settings.arguments;
        //   return SignUpOtpScreen(i);
        // },
        allActorsInCategoryScreenRoute: (context) =>
            const AllActorsInCategoryScreen(),
        loginScreenRoute: (context) => const LoginScreen(),
        emailVerificationScreenRoute: (context) =>
            const EmailVerificationScreen(),
        bookingCalendarScreenRoute: (context) {
          var i = ModalRoute.of(context)!.settings.arguments;
          return BookingCalendarScreen(i);
        },
        celebrityProfileScreenRoute: (context) {
          var i = ModalRoute.of(context)!.settings.arguments;
          return CelebrityProfileScreen(i);
        },
        homeScreenRoute: (context) => const HomeScreen(),
        checkoutScreenRoute: (context) {
          var i = ModalRoute.of(context)!.settings.arguments;
          log("this is data of this ${i}");
          return CheckoutScreen(i);
        },
        // upcomingVideoAppointmentDetailsScreenRoute: (context) =>
        //     const UpcomingVideoAppointmentDetailsScreen(),
        // upcomingAudioAppointmentDetailsScreenRoute: (context) =>
        //      UpcomingAudioAppointmentDetailsScreen(),
        signUpScreenRoute: (context) => const SignUpScreen(),
        personalDetailsSettingsScreenRoute: (context) =>
            const PersonalDetailsSettingsScreen(),
        faqScreenRoute: (context) => const FaqScreen(),
        favouritesScreenRoute: (context) => FavouritesScreen(),
        allCategoriesScreenRoute: (context) => const AllCategoriesScreen(),
        audioCallingScreenRoute: (context) => const AudioCallingScreen(),
        forgotPasswordScreenRoute: (context) => const ForgotPasswordScreen(),
        videoCallingScreenRoute: (context) => const VideoCallingScreen(),
        profileScreenRoute: (context) => const ProfileScreen(),
        settingsScreenRoute: (context) => const SettingsScreen(),
        helpScreenRoute: (context) => const HelpScreen(),
        reviewsScreenRoute: (context) => const ReviewsScreen(),
        privacyPolicyScreenRoute: (context) => const PrivacyPolicyScreen(),
        // cancelledAppointmentDetailsScreenRoute: (context) =>
        //      CancelledAppointmentDetailsScreen(),
        termsOfUseScreenRoute: (context) => const TermsOfUseScreen(),
        historyAppointmentDetailsScreenRoute: (context) =>
            const HistoryAppointmentDetailsScreen(),
        notificationsScreenRoute: (context) => const NotificationsScreen(),
        enrollAsStarScreenRoute: (context) => const EnrollAsStarScreen(),
        cancelledAppointmentScreenRoute: (context) =>
            const CancelledAppointmentScreen(),
        appointmentScreenRoute: (context) => const AppointmentScreen(),
        changePasswordScreenRoute: (context) => const ChangePasswordScreen(),
      },
    );
  }
}
