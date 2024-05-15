import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:starsmeetupuser/Apis/appointment_apis.dart';
import 'package:starsmeetupuser/Screens/AppointmentScreens/appointment_screen.dart';
import 'package:starsmeetupuser/Utilities/app_routes.dart';
import 'package:starsmeetupuser/chat/audio_Calls.dart';
import 'package:starsmeetupuser/chat/calls.dart';

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
  final AppointmentService _appointmentService = AppointmentService();
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AgoraCalls()));
                  // Navigator.pushNamed(context, videoCallingScreenRoute);
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
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder(
                          future:
                              _appointmentService.cancelAppointmentsByUserId(
                                  widget.appointment.userId!,
                                  widget.appointment.timeSlotId!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return TextButton(
                                  onPressed: () {
                                    setState(() {
                                      showPopUp(context);
                                      // _appointmentService
                                      //     .cancelAppointmentsByUserId(
                                      //         widget.appointment.userId!,
                                      //         widget.appointment.timeSlotId!)
                                      //     .whenComplete(() {
                                      //   Navigator.pop(context);
                                      //   Navigator.pop(context);
                                      //   Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             AppointmentScreen()),
                                      //   );
                                      // });
                                    });
                                  },
                                  child: Text(
                                    "Cancel Appointment",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.red,
                                        decorationThickness: 2.0),
                                  ));
                            }
                          }),
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

  showPopUp(pageContext) {
    showGeneralDialog(
      context: pageContext,
      barrierLabel: "Barrier2",
      transitionDuration: const Duration(seconds: 0),
      barrierDismissible: true,
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(builder: (context, setState) {
          return Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(pageContext).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 240,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Alert",
                          style: twentyFive700TextStyle(color: purpleColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        "Do you want to cancel this Appointment?",
                        style: eighteen700TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 1,
                            ),
                            Text(
                              "No",
                              style: eighteen600TextStyle(
                                color: purpleColor,
                              ),
                            ),
                            BigButton(
                              width:
                                  MediaQuery.of(pageContext).size.width * 0.4,
                              height: 45,
                              color: purpleColor,
                              text: "Yes",
                              onTap: () {
                                _appointmentService
                                    .cancelAppointmentsByUserId(
                                        widget.appointment.userId!,
                                        widget.appointment.creationTimestamp!)
                                    .whenComplete(() {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AppointmentScreen()),
                                  );
                                });
                                setState(() {});
                              },
                              borderRadius: 5.0,
                              textStyle:
                                  eighteen700TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
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
