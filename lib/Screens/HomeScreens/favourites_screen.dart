import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:starsmeetupuser/models/celebrity_model.dart';

import '../../Apis/celebrities_apis.dart';
import '../../Utilities/app_colors.dart';
import '../../Utilities/app_text_styles.dart';

class FavouritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<CelebrityModel>>(
        stream: CelebritiesService()
            .streamCelebrities(), // Stream of all celebrities
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for data
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show an error message if an error occurs
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Handle case where no data is available
            return Center(child: Text('No favorite celebrities'));
          } else {
            // Filter favorite celebrities from the snapshot data
            List<CelebrityModel> favoriteCelebrities = snapshot.data!
                .where((celebrity) => celebrity.favorite == true)
                .toList();

            // Show favorite celebrities in the UI
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                        Text(
                          "Favourites",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Display favorite celebrities
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: favoriteCelebrities.length,
                    itemBuilder: (context, index) {
                      CelebrityModel celebrity = favoriteCelebrities[index];
                      return Column(
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
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/celebrityImage.png"),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      celebrity.name ?? '',
                                      style: twenty700TextStyle(
                                          color: purpleColor),
                                    ),
                                    const SizedBox(
                                      height: 0,
                                    ),
                                    Text(
                                      celebrity.category ?? '',
                                      style: sixteen400TextStyle(
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () async {
                                    await CelebritiesService()
                                        .removeFromFavorites(
                                            '', celebrity.userID ?? '');
                                    EasyLoading.showSuccess(
                                        "Removed from favorites");
                                  },
                                  child: const Icon(
                                    Icons.favorite_outlined,
                                    color: redColor,
                                    size: 40,
                                  ),
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
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
