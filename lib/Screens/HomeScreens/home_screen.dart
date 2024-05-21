import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:starsmeetupuser/GlobalWidgets/text_field_widget.dart';
import 'package:starsmeetupuser/Utilities/app_colors.dart';
import 'package:starsmeetupuser/Utilities/app_text_styles.dart';

import '../../Apis/celebrities_apis.dart';
import '../../Apis/notificationController.dart';
import '../../GlobalWidgets/categories_widget.dart';
import '../../GlobalWidgets/celebrity_widget.dart';
import '../../GlobalWidgets/home_category_and_featured_widget.dart';
import '../../GlobalWidgets/side_drawer_widget.dart';
import '../../Utilities/app_routes.dart';
import '../../models/celebrity_model.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  NotificationController controller = Get.put(NotificationController());
  List<String> categories = [
    "Creators",
    "Comedians",
    "Music",
    "Actors",
    "Mentors",
    "Anchors",
    "Sports",
    "TikTok",
  ];
  List<LinearGradient> gradients = [
    const LinearGradient(
      colors: [Color(0xff2E3192), Color(0xff1BFFFF)],
    ),
    const LinearGradient(
      colors: [Color(0xffD4145A), Color(0xffFBB03B)],
    ),
    const LinearGradient(
      colors: [Color(0xff009245), Color(0xffFCEE21)],
    ),
    const LinearGradient(
      colors: [Color(0xff662D8C), Color(0xffED1E79)],
    ),
    const LinearGradient(
      colors: [Color(0xffEE9CA7), Color(0xffFFDDE1)],
    ),
    const LinearGradient(
      colors: [Color(0xff614385), Color(0xff516395)],
    ),
    const LinearGradient(
      colors: [Color(0xff02AABD), Color(0xff00CDAC)],
    ),
    const LinearGradient(
      colors: [Color(0xffFF512F), Color(0xffDD2476)],
    ),
    const LinearGradient(
      colors: [Color(0xffFF5F6D), Color(0xffFFC371)],
    ),
    const LinearGradient(
      colors: [Color(0xff11998E), Color(0xff38EF7D)],
    ),
    const LinearGradient(
      colors: [Color(0xffEA8D8D), Color(0xffA890FE)],
    ),
    const LinearGradient(
      colors: [Color(0xff09203F), Color(0xff537895)],
    ),
  ];

  void openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  List<CelebrityModel>? celebrities;
  int notificationCount = 0;

  @override
  void initState() {
    getCelebritiesList();
    _getNotificationCount();
    super.initState();
  }

  Future<void> _getNotificationCount() async {
    int count = await controller.getNotificationCount();
    setState(() {
      notificationCount = count;
    });
  }

  getCelebritiesList() async {
    celebrities = await CelebritiesService().fetchCelebrities();
    if (kDebugMode) {
      print(celebrities);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var isLoggedIn = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: DrawerWidget(scaffoldKey: _scaffoldKey),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isLoggedIn == true
                    ? GestureDetector(
                        onTap: openDrawer,
                        child: Image.asset(
                          "assets/sideMenuIcon.png",
                          width: 25,
                          height: 25,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, loginScreenRoute);
                        },
                        child: Container(
                          width: 80,
                          height: 25,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: const Center(
                            child: Text(
                              "Login",
                            ),
                          ),
                        ),
                      ),
                Image.asset(
                  "assets/logo.png",
                  width: isLoggedIn == true ? 200 : 170,
                  height: 30,
                ),
                isLoggedIn == true
                    ? GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, notificationsScreenRoute);
                          setState(() {
                            notificationCount = 0;
                          });
                          // print(
                          //     "this is date only: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}");
                        },
                        child:
                            Stack(
                          children: [
                            Icon(
                              Icons.notifications_active_outlined,
                              size: 30.0,
                            ),
                            notificationCount == 0
                                ? SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: AnimatedContainer(
                                    
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffDC1818),
                                      ),
                                      duration: Duration(microseconds:20),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Text(
                                            '${notificationCount}',
                                            style: TextStyle(color: Colors.white,fontSize: 9),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, signUpScreenRoute);
                        },
                        child: Container(
                          width: 80,
                          height: 25,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: purpleColor,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: const Center(
                            child: Text(
                              "Sign up",
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextFieldWidget(
              hintText: "Search",
              labelText: "",
              obscureText: false,
              suffixIcon: Icon(
                Icons.search,
                color: purpleColor,
                size: 25,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Categories",
                  style: twentyTwo700TextStyle(color: purpleColor),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, allCategoriesScreenRoute,
                        arguments: celebrities);
                  },
                  child: const Text(
                    "View all",
                    style: TextStyle(
                      color: purpleColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          celebrities == null
              ? const CupertinoActivityIndicator()
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      for (int i = 0; i < categories.length; i++)
                        celebrities!
                                .where((element) =>
                                    element.category == categories[i])
                                .toList()
                                .isNotEmpty
                            ? CategoriesWidget(
                                text: categories[i],
                                gradient: gradients[i],
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, allActorsInCategoryScreenRoute,
                                      arguments: [
                                        categories[i],
                                        celebrities!
                                            .where((element) =>
                                                element.category ==
                                                categories[i])
                                            .toList()
                                      ]);
                                },
                              )
                            : const SizedBox(),
                    ],
                  ),
                ),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            color: Colors.grey,
            height: 1,
          ),
          const SizedBox(
            height: 10,
          ),
          celebrities == null
              ? const CupertinoActivityIndicator()
              : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < categories.length; i++)
                          celebrities!
                                  .where((element) =>
                                      element.category == categories[i])
                                  .toList()
                                  .isNotEmpty
                              ? HomeCategoryAndFeaturedWidget(
                                  nameOfCategory: categories[i],
                                  onTapViewAll: () {
                                    Navigator.pushNamed(
                                        context, allActorsInCategoryScreenRoute,
                                        arguments: [
                                          categories[i],
                                          celebrities!
                                              .where((element) =>
                                                  element.category ==
                                                  categories[i])
                                              .toList()
                                        ]);
                                  },
                                  childWidget: celebrities!
                                          .where((element) =>
                                              element.category == categories[i])
                                          .toList()
                                          .isNotEmpty
                                      ? Row(
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            for (int j = 0;
                                                j <
                                                    min(
                                                        5,
                                                        celebrities!
                                                            .where((element) =>
                                                                element
                                                                    .category ==
                                                                categories[i])
                                                            .length);
                                                j++)
                                              CelebrityWidget(
                                                name: celebrities!
                                                    .where((element) =>
                                                        element.category ==
                                                        categories[i])
                                                    .toList()[j]
                                                    .name!,
                                                image: celebrities!
                                                    .where((element) =>
                                                        element.category ==
                                                        categories[i])
                                                    .toList()[j]
                                                    .profilePicture,
                                                onTap: () {
                                                  Navigator.pushNamed(context,
                                                      celebrityProfileScreenRoute,
                                                      arguments: celebrities!
                                                          .where((element) =>
                                                              element
                                                                  .category ==
                                                              categories[i])
                                                          .toList()[j]);
                                                },
                                              )
                                          ],
                                        )
                                      : Container(),
                                )
                              : Container(),
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
