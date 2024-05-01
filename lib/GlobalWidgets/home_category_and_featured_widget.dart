import 'package:flutter/material.dart';

import '../Utilities/app_colors.dart';
import '../Utilities/app_text_styles.dart';

class HomeCategoryAndFeaturedWidget extends StatelessWidget {
  final String nameOfCategory;
  final VoidCallback onTapViewAll;
  final Widget childWidget;
  const HomeCategoryAndFeaturedWidget({
    super.key,
    required this.nameOfCategory,
    required this.onTapViewAll,
    required this.childWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  nameOfCategory,
                  style: twentyTwo700TextStyle(color: purpleColor),
                ),
                GestureDetector(
                  onTap: onTapViewAll,
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
          SingleChildScrollView(
              scrollDirection: Axis.horizontal, child: childWidget),
        ],
      ),
    );
  }
}
