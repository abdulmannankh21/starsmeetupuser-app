import 'package:flutter/material.dart';
import 'package:starsmeetupuser/GlobalWidgets/categories_widget.dart';
import 'package:starsmeetupuser/models/celebrity_model.dart';

import '../../Utilities/app_colors.dart';
import '../../Utilities/app_routes.dart';
import '../../Utilities/app_text_styles.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
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

  @override
  Widget build(BuildContext context) {
    List<CelebrityModel> celebrities =
        ModalRoute.of(context)!.settings.arguments as List<CelebrityModel>;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
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
                    "Categories",
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
              celebrities.isEmpty
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 200,
                        ),
                        Center(
                          child: Text("No Categories Available"),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceBetween,
                        runSpacing: 20.0,
                        children: [
                          for (int i = 0; i < categories.length; i++)
                            celebrities
                                    .where((element) =>
                                        element.category == categories[i])
                                    .toList()
                                    .isNotEmpty
                                ? CategoriesWidget(
                                    text: categories[i],
                                    gradient: gradients[i],
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        allActorsInCategoryScreenRoute,
                                        arguments: [
                                          categories[i],
                                          celebrities
                                              .where((element) =>
                                                  element.category ==
                                                  categories[i])
                                              .toList()
                                        ],
                                      );
                                    },
                                  )
                                : const SizedBox(),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
