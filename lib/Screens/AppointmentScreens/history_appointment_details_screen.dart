import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../GlobalWidgets/button_widget.dart';
import '../../GlobalWidgets/expanded_text_field_widget.dart';
import '../../Utilities/app_colors.dart';
import '../../Utilities/app_text_styles.dart';

class HistoryAppointmentDetailsScreen extends StatefulWidget {
  const HistoryAppointmentDetailsScreen({super.key});

  @override
  State<HistoryAppointmentDetailsScreen> createState() =>
      _HistoryAppointmentDetailsScreenState();
}

class _HistoryAppointmentDetailsScreenState
    extends State<HistoryAppointmentDetailsScreen> {
  bool value = true;
  bool added = false;
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
                    "Details",
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
            Center(
              child: Container(
                width: 190,
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: const DecorationImage(
                    image: AssetImage(
                      "assets/celebrityImage.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Hamza Ali Abbasi",
                style: twentyTwo700TextStyle(color: purpleColor),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "Completed",
                style: twentyTwo700TextStyle(color: greenColor),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            added == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RatingBar.builder(
                        initialRating: 5,
                        itemSize: 20,
                        minRating: 1,
                        direction: Axis.horizontal,
                        glowColor: purpleColor,
                        updateOnDrag: false,
                        unratedColor: Colors.grey[700],
                        itemCount: 5,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "5.0",
                        style: eighteen600TextStyle(color: Colors.black),
                      ),
                    ],
                  )
                : Center(
                    child: BigButton(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 55,
                      color: darkGreyColor,
                      text: "Submit Review",
                      onTap: () async {
                        added = true;
                        setState(() {});
                        await showReviewPopUp(context);
                      },
                      textStyle: twentyTwo700TextStyle(color: Colors.white),
                    ),
                  ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Meeting Details",
                    style: twentyTwo700TextStyle(color: purpleColor),
                  ),
                  Text(
                    "Time: 12:10 AM",
                    style: twenty600TextStyle(color: darkGreyColor),
                  ),
                  Text(
                    "Date: 12-May-2024",
                    style: twenty600TextStyle(color: darkGreyColor),
                  ),
                  Text(
                    "Meeting Type: Audio Meeting",
                    style: twenty600TextStyle(color: darkGreyColor),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Payment Details",
                    style: twentyTwo700TextStyle(color: purpleColor),
                  ),
                  Text(
                    "Order#124124",
                    style: twenty600TextStyle(color: darkGreyColor),
                  ),
                  Text(
                    "Meeting Type: Audio Meeting",
                    style: twenty600TextStyle(color: darkGreyColor),
                  ),
                  Text(
                    "Paid Amount: Rs. 6,000",
                    style: twenty600TextStyle(color: darkGreyColor),
                  ),
                  Text(
                    "Payment Type: Credit Card",
                    style: twenty600TextStyle(color: darkGreyColor),
                  ),
                  Text(
                    "Paid on 11th Jan 2023   3:00 PM",
                    style: twenty600TextStyle(color: darkGreyColor),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 1,
              thickness: 1.5,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "How to Join Meeting",
                style: twentyTwo700TextStyle(color: purpleColor),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 400,
              decoration: const BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(
                  image: AssetImage("assets/celebrityImage.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.play_circle_outline_rounded,
                  color: Colors.white,
                  size: 70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showReviewPopUp(pageContext) {
    showGeneralDialog(
      context: pageContext,
      barrierLabel: "Barrier",
      transitionDuration: const Duration(seconds: 0),
      barrierDismissible: true,
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(builder: (context, setState) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(pageContext).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    height: 650,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Review",
                            style: twentyTwo700TextStyle(color: purpleColor),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Container(
                              width: 120,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: const DecorationImage(
                                  image: AssetImage(
                                    "assets/celebrityImage.png",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              "Hamza Ali Abbasi",
                              style: twentyTwo700TextStyle(color: purpleColor),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RatingBar.builder(
                            initialRating: 3,
                            itemSize: 50,
                            minRating: 1,
                            direction: Axis.horizontal,
                            glowColor: purpleColor,
                            unratedColor: Colors.grey[700],
                            itemCount: 5,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                          const ExpandedTextFieldWidget(
                            hintText: "Leave a message, if you want",
                            lablelText: "",
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          BigButton(
                            width: MediaQuery.of(pageContext).size.width * 0.75,
                            height: 50,
                            color: purpleColor,
                            text: "Submit",
                            onTap: () {
                              Navigator.pop(pageContext);
                            },
                            borderRadius: 5.0,
                            textStyle:
                                eighteen700TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Maybe Later",
                            style: sixteen700TextStyle(
                              color: purpleColor,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
