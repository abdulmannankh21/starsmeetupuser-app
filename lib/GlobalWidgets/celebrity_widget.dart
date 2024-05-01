import 'package:flutter/material.dart';

import '../Utilities/app_text_styles.dart';

class CelebrityWidget extends StatelessWidget {
  final String name;
  final String? image;
  final VoidCallback onTap;
  const CelebrityWidget({
    super.key,
    required this.name,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 130,
            height: 170,
            decoration: image == null
                ? BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/dummProfileIcon.png"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  )
                : BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(image!),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            name,
            style: sixteen500TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class AllCelebrityWidget extends StatelessWidget {
  final String name;
  final String? image;
  final VoidCallback onTap;
  const AllCelebrityWidget({
    super.key,
    required this.name,
    this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 168,
            height: 200,
            decoration: image == null
                ? BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/dummProfileIcon.png"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  )
                : BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(image!),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            name,
            style: eighteen500TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
