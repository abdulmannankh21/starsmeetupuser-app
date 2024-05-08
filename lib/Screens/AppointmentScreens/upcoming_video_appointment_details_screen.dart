import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:starsmeetupuser/Utilities/app_routes.dart';

import '../../GlobalWidgets/button_widget.dart';
import '../../Utilities/app_colors.dart';
import '../../Utilities/app_text_styles.dart';
import '../../models/appointment_model.dart';

class UpcomingVideoAppointmentDetailsScreen extends StatefulWidget {
  AppointmentModel appointment = AppointmentModel();

  UpcomingVideoAppointmentDetailsScreen({required this.appointment, super.key});

  @override
  State<UpcomingVideoAppointmentDetailsScreen> createState() =>
      _UpcomingVideoAppointmentDetailsScreenState();
}

class _UpcomingVideoAppointmentDetailsScreenState
    extends State<UpcomingVideoAppointmentDetailsScreen> {
  bool value = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("this is video deatls screen: ${widget.appointment.celebrityImage}");
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
                  image: DecorationImage(
                    image: NetworkImage(
                      "${widget.appointment.celebrityImage}",
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
                "${widget.appointment.celebrityName}",
                style: twentyTwo700TextStyle(color: purpleColor),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: BigButton(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 55,
                color: purpleColor,
                text: "Join Meeting",
                onTap: () {
                  Navigator.pushNamed(context, videoCallingScreenRoute);
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
                    "Time: ${DateFormat('h:mm a').format(widget.appointment.startTime!)}-${DateFormat('h:mm a').format(widget.appointment.endTime!)}",
                    style: twenty600TextStyle(color: darkGreyColor),
                  ),
                  Text(
                    "Date: ${DateFormat('dd-MMM-yy').format(widget.appointment.selectedDate!)}",
                    style: twenty600TextStyle(color: darkGreyColor),
                  ),
                  Text(
                    "Meeting Type: ${widget.appointment.serviceName}",
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
                    "Meeting Type: ${widget.appointment.serviceName}",
                    style: twenty600TextStyle(color: darkGreyColor),
                  ),
                  Text(
                    "Paid Amount: Rs. ${widget.appointment.servicePrice}",
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
              decoration: BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(
                  image: NetworkImage("${widget.appointment.celebrityImage}"),
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
}
