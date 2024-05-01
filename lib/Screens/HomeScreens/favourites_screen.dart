import 'package:flutter/material.dart';

import '../../Utilities/app_colors.dart';
import '../../Utilities/app_text_styles.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
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
                    "Favourites",
                    style: twentyTwo700TextStyle(color: purpleColor),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            for (int i = 0; i < 5; i++)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 90,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage("assets/celebrityImage.png"),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hamza Ali Abbasi",
                              style: twenty700TextStyle(color: purpleColor),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Actor",
                              style: sixteen400TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.favorite_outlined,
                          color: redColor,
                          size: 40,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
