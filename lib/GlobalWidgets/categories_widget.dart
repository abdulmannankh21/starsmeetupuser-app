import 'package:flutter/material.dart';

import '../Utilities/app_text_styles.dart';

class CategoriesWidget extends StatelessWidget {
  final String text;
  final LinearGradient gradient;
  final VoidCallback onTap;
  const CategoriesWidget({
    super.key,
    required this.text,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        width: 160,
        height: 80,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            text,
            style: eighteen700TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
