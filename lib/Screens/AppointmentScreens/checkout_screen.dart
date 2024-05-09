// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:starsmeetupuser/Apis/notificationController.dart';
import 'package:starsmeetupuser/Utilities/app_routes.dart';
import 'package:starsmeetupuser/models/notification_Model.dart';

import '../../Apis/appointment_apis.dart';
import '../../Apis/promo_code_apis.dart';
import '../../GlobalWidgets/big_border_button.dart';
import '../../GlobalWidgets/button_widget.dart';
import '../../Utilities/app_colors.dart';
import '../../Utilities/app_text_styles.dart';
import '../../models/appointment_model.dart';
import '../../models/promo_code_model.dart';

class CheckoutScreen extends StatefulWidget {
  var data;
  CheckoutScreen(this.data, {super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int selected = -1;
  int selected2 = -1;
  AppointmentModel? appointment;
  late NotificationModel notification;
  var promoCodeController = TextEditingController();
  String? supportYourStarAmount;
  NotificationController controller = Get.put(NotificationController());
  assignModel() {
    log("this is data:${widget.data}");
    appointment = widget.data as AppointmentModel;
    Map<String, dynamic> datee = {
      "serviceName": appointment!.serviceName,
      "celebrityName": appointment!.celebrityName,
      "userId": appointment!.userId,
      "userName": appointment!.userName,
      "creationTimestamp": DateTime.now().toString(),
      "status": "active",
    };
    notification = NotificationModel.fromJson(datee);

    // log("this is map data; ${notification.celebrityName}");
    setState(() {});
  }

  @override
  void initState() {
    assignModel();
    super.initState();
  }

  checkPromoCode() async {
    PromoCodeModel? promoCodeModel =
        await PromoCodeService().getPromoCode(promoCodeController.text);

    if (promoCodeModel != null) {
      print(promoCodeModel);
      EasyLoading.showSuccess("Promo Code Applied!");
    } else {
      promoCodeController.clear();
      setState(() {});
    }
  }

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
                    "Checkout",
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
              child: Text(
                appointment!.serviceName ?? "",
                style: twenty700TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Date: ",
                        style: sixteen600TextStyle(color: Colors.black),
                      ),
                      Text(
                        DateFormat('MMMM d, y')
                            .format(appointment!.selectedDate!),
                        style: sixteen600TextStyle(color: greenColor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Time: ",
                        style: sixteen600TextStyle(color: Colors.black),
                      ),
                      Text(
                        DateFormat('hh:mm a').format(appointment!.startTime!),
                        style: sixteen600TextStyle(color: greenColor),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 130,
                    height: 170,
                    decoration: appointment!.celebrityImage == ""
                        ? BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage("assets/dummProfileIcon.png"),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(10.0),
                          )
                        : BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(appointment!.celebrityImage!),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Text(
                        appointment!.celebrityName ?? "",
                        style: twenty700TextStyle(color: purpleColor),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Rs. ${appointment!.servicePrice ?? "0"}",
                        style: twenty700TextStyle(color: purpleColor),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Promo Code",
                style: twenty700TextStyle(color: purpleColor),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: TextFormField(
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        controller: promoCodeController,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.attach_money,
                            color: purpleColor,
                            size: 25,
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          hintText: "Promo code",
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.grey[600]!,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  BigButton(
                    width: 100,
                    height: 55,
                    color: purpleColor,
                    text: "Apply",
                    onTap: () {
                      if (promoCodeController.text != "") {
                        checkPromoCode();
                      }
                    },
                    textStyle: twentyTwo700TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: BigBorderButton(
                      width: MediaQuery.of(context).size.width,
                      height: 55,
                      color: Colors.grey[500]!,
                      text: selected != -1
                          ? supportYourStarAmount!
                          : "Support Your Star",
                      onTap: () {
                        supportBottomSheet();
                      },
                      textStyle: twenty700TextStyle(color: purpleColor),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  selected != -1
                      ? Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                selected = -1;
                                setState(() {});
                              },
                              child: const Icon(
                                Icons.delete_forever_rounded,
                                color: redColor,
                                size: 30,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              supportYourStarAmount!,
                              style: eighteen600TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
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
                    "Discount Applied",
                    style: eighteen600TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Rs. 1,000",
                    style: eighteen600TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Charges",
                    style: eighteen700TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Rs. 1,000",
                    style: eighteen700TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Select Payment Method",
                style: twenty700TextStyle(color: purpleColor),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            for (int i = 0; i < 3; i++)
              GestureDetector(
                onTap: () {
                  selected2 = i;
                  setState(() {});
                },
                child: Container(
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
                  margin:
                      const EdgeInsets.only(bottom: 15, left: 20, right: 20),
                  child: Row(
                    children: [
                      Image.asset(
                        i == 0
                            ? "assets/debitCardImage.png"
                            : i == 1
                                ? "assets/jazzcashImage.png"
                                : "assets/easyPaisaImage.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        i == 0
                            ? "Debit/Credit Card"
                            : i == 1
                                ? "Jazz Cash Account"
                                : "Easy Paisa Account",
                        style: twenty600TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: purpleColor,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: i == selected2
                            ? Center(
                                child: Container(
                                  width: 13,
                                  height: 13,
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
                    ],
                  ),
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: BigButton(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 55,
                color: purpleColor,
                text: "Complete Payment",
                onTap: () async {
                  EasyLoading.show(status: "Loading...");
                  appointment!.creationTimestamp =
                      DateFormat('yyyy-MM-dd').format(DateTime.now());
                  appointment!.promoCode = promoCodeController.text;
                  appointment!.status = "active";

                  await AppointmentService()
                      .uploadAppointment(appointment!)
                      .then((value) async {
                    await controller
                        .uploadNotification(notification!)
                        .whenComplete(() {
                      EasyLoading.showSuccess(
                          "Appointment Created Successfully!");
                      Navigator.pushNamedAndRemoveUntil(
                          context, homeScreenRoute, (route) => true,
                          arguments: true);
                    });
                  });
                },
                textStyle: twentyTwo700TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  supportBottomSheet() {
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
                          selected = i;
                          supportYourStarAmount = "Rs. ${i + 1},000";
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
                                child: i == selected
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
                                "Rs. ${i + 1},000",
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
  }
}
