import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:starsmeetupuser/models/celebrity_model.dart';

import '../../GlobalWidgets/celebrity_widget.dart';
import '../../GlobalWidgets/text_field_widget.dart';
import '../../Utilities/app_colors.dart';
import '../../Utilities/app_routes.dart';
import '../../Utilities/app_text_styles.dart';

class AllActorsInCategoryScreen extends StatefulWidget {
  const AllActorsInCategoryScreen({super.key});

  @override
  State<AllActorsInCategoryScreen> createState() =>
      _AllActorsInCategoryScreenState();
}

class _AllActorsInCategoryScreenState extends State<AllActorsInCategoryScreen> {
  GlobalKey<DropdownButton2State> dropDownKey =
      GlobalKey<DropdownButton2State>();

  final List<String> items = [
    'Sort A-Z',
    'Relevance',
  ];
  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments as List;
    var categoryName = data[0];
    List<CelebrityModel> celebrities = data[1];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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
                  categoryName,
                  style: twentyTwo700TextStyle(color: purpleColor),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          dropDownKey.currentState!.callTap();
                        },
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.grey[600]!,
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              "assets/filtersIcon.png",
                              width: 30,
                              height: 30,
                              color: Colors.grey[600]!,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 80,
                        right: 0,
                        left: 0,
                        child: SizedBox(
                          width: 140,
                          height: 0,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              key: dropDownKey,
                              isExpanded: true,
                              iconStyleData: const IconStyleData(
                                iconDisabledColor: Colors.transparent,
                                iconEnabledColor: Colors.transparent,
                              ),

                              dropdownStyleData: DropdownStyleData(
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                  padding: EdgeInsets.only(
                                    left: 0,
                                    right: 0,
                                  ),
                                  height: 40),
                              style: const TextStyle(color: whiteColor),
                              items: items
                                  .map(
                                    (item) => DropdownMenuItem<String>(
                                      alignment: Alignment.center,
                                      value: item,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12,
                                                top: 10,
                                                right: 12,
                                                bottom: 10),
                                            child: Center(
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          items.indexOf(item) != 1
                                              ? const Divider(
                                                  height: 1,
                                                  color: Colors.black,
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
// value: controller.selectedValue,
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                const Expanded(
                  child: TextFieldWidget(
                    hintText: "Search",
                    obscureText: false,
                    labelText: "",
                    suffixIcon: Icon(
                      Icons.search,
                      color: purpleColor,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.spaceBetween,
                    runSpacing: 10.0,
                    children: [
                      for (int i = 0; i < celebrities.length; i++)
                        AllCelebrityWidget(
                          onTap: () {
                            Navigator.pushNamed(
                                context, celebrityProfileScreenRoute,
                                arguments: celebrities[i]);
                          },
                          name: celebrities[i].name!,
                          image: celebrities[i].profilePicture,
                        ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
