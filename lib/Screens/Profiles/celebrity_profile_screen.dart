// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:starsmeetupuser/LocalStorage/shared_preferences.dart';
import 'package:starsmeetupuser/models/celebrity_model.dart';

import '../../Apis/celebrities_services_apis.dart';
import '../../Apis/how_to_video_apis.dart';
import '../../GlobalWidgets/big_border_button.dart';
import '../../GlobalWidgets/button_widget.dart';
import '../../GlobalWidgets/video_widget.dart';
import '../../Utilities/app_colors.dart';
import '../../Utilities/app_routes.dart';
import '../../Utilities/app_text_styles.dart';
import '../../models/appointment_model.dart';
import '../../models/celebrity_services_model.dart';

class CelebrityProfileScreen extends StatefulWidget {
  var data;
  CelebrityProfileScreen(this.data, {super.key});

  @override
  State<CelebrityProfileScreen> createState() => _CelebrityProfileScreenState();
}

class _CelebrityProfileScreenState extends State<CelebrityProfileScreen> {
  String selectedValue = '';
  int selected = -1;
  CelebrityModel? celebrityDetails;
  String attachmentVideo = '';

  List<CelebrityServicesModel>? celebritiesServices;
  List<String> servicesList = [];
  var buyMeACoffeePrice = ["1,000", "2,000", "3,000", "4,000"];
  getServices() async {
    celebritiesServices =
        await CelebrityServicesService().getCelebrityService();
    if (kDebugMode) {
      print(celebritiesServices);
    }
    for (int i = 0; i < celebritiesServices!.length; i++) {
      servicesList.add(
          "${celebritiesServices![i].title}      (${celebritiesServices![i].durationMinutes} min)    Rs. ${celebritiesServices![i].price}");
    }
    setState(() {});
  }

  getVideo() async {
    attachmentVideo = await VideosService().getVideo();
    setState(() {});
    if (kDebugMode) {
      print(attachmentVideo);
    }
  }

  @override
  void initState() {
    celebrityDetails = widget.data as CelebrityModel;
    getVideo();
    getServices();
    super.initState();
  }

  AppointmentModel? appointment;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 350,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: celebrityDetails!.backgroundPicture != null
                        ? BoxDecoration(
                            color: purpleColor,
                            image: DecorationImage(
                              image: NetworkImage(
                                celebrityDetails!.backgroundPicture!,
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                          )
                        : const BoxDecoration(
                            color: purpleColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                          ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Spacer(),
                        celebrityDetails!.backgroundPicture == null
                            ? const Column(
                                children: [
                                  Center(
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 100,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const Spacer(
                          flex: 5,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: 150,
                      height: 180,
                      decoration: celebrityDetails!.profilePicture != null
                          ? BoxDecoration(
                              color: purpleColor,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  celebrityDetails!.profilePicture!,
                                ),
                                fit: BoxFit.cover,
                              ))
                          : BoxDecoration(
                              color: purpleColor,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                      child: celebrityDetails!.profilePicture == null
                          ? const Center(
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 100,
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    celebrityDetails!.name ?? "Loading",
                    style: twentyTwo700TextStyle(
                      color: purpleColor,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RatingBar.builder(
                    initialRating: 5,
                    itemSize: 20,
                    minRating: 1,
                    direction: Axis.horizontal,
                    glowColor: purpleColor,
                    updateOnDrag: false,
                    unratedColor: Colors.grey[700],
                    allowHalfRating: true,
                    itemCount: 5,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 55,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[500]!,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: DropdownButton<String>(
                      hint: Text(
                        "Select Service",
                        style: eighteen500TextStyle(
                          color: purpleColor,
                        ),
                      ),
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      value: selectedValue.isNotEmpty ? selectedValue : null,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 24,
                      elevation: 16,
                      style: sixteen400TextStyle(
                        color: Colors.white,
                      ),
                      underline: Container(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                        List<String> serviceInfo = selectedValue.split("    ");
                        String title = serviceInfo[0];
                        String duration = serviceInfo[1];

                        appointment = AppointmentModel(
                          serviceName: title,
                          servicePrice: serviceInfo[2].substring(4),
                          serviceDuration: duration,
                          celebrityName: celebrityDetails!.name ?? "",
                          celebrityId: celebrityDetails!.userID ?? "",
                          userId: MyPreferences.instance.user!.userID,
                          userName: MyPreferences.instance.user!.name,
                          celebrityImage:
                              celebrityDetails!.profilePicture ?? "",
                        );
                      },
                      items: servicesList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Text(
                                value,
                                style: sixteen600TextStyle(color: purpleColor),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BigButton(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 55,
                    color: purpleColor,
                    text: "Book Appointment",
                    onTap: () {
                      if (appointment != null) {
                        if (kDebugMode) {
                          print(appointment!.toJson());
                        }
                        Navigator.pushNamed(context, bookingCalendarScreenRoute,
                            arguments: appointment);
                      } else {
                        EasyLoading.showError("Please select a service!");
                      }
                    },
                    textStyle: twenty700TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: celebrityDetails!.supportYourStar != true
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      celebrityDetails!.supportYourStar == true
                          ? Expanded(
                              child: BigBorderButton(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 55,
                                color: Colors.grey[500]!,
                                text: selected == -1
                                    ? "Support Your Star"
                                    : "Rs. ${NumberFormat('#,###').format(selected)}",
                                onTap: () {
                                  supportBottomSheet();
                                },
                                textStyle:
                                    twenty700TextStyle(color: purpleColor),
                              ),
                            )
                          : const SizedBox(),
                      celebrityDetails!.supportYourStar == true
                          ? const SizedBox(
                              width: 10,
                            )
                          : const SizedBox(),
                      Container(
                        width: 45,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.grey[500]!,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.favorite_outlined,
                            color: redColor,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              height: 1,
              thickness: 1.5,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  celebrityDetails!.bio ?? "No Description Added Yet!",
                  style: eighteen500TextStyle(color: Colors.black),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              height: 1,
              thickness: 1.5,
            ),
            const SizedBox(
              height: 10,
            ),
            attachmentVideo != ""
                ? VideoWidget(
                    pinnedPostVideo: attachmentVideo,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  supportBottomSheet() {
    var flag = 0;
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (builder) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter mystate) {
            return SizedBox(
              height: 400.0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    for (int i = 0; i < 4; i++)
                      GestureDetector(
                        onTap: () {
                          selected = int.parse(
                              buyMeACoffeePrice[i].replaceAll(',', ''));
                          flag = i;
                          print(selected);
                          mystate(() {});
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[400]!,
                                offset: const Offset(0, 1),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: purpleColor,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: i == flag
                                    ? Center(
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: purpleColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Image.asset(
                                i == 0
                                    ? "assets/cupImage.png"
                                    : i == 1
                                        ? "assets/cocktail.png"
                                        : i == 2
                                            ? "assets/burger.png"
                                            : "assets/pizza.png",
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Rs. ${buyMeACoffeePrice[i]}",
                                style: twenty600TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const Spacer(),
                    BigButton(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 55,
                      color: purpleColor,
                      text: "Pay",
                      onTap: () {
                        Navigator.pop(context);
                        mystate(() {});
                      },
                      textStyle: twenty700TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    return selected;
  }
}
