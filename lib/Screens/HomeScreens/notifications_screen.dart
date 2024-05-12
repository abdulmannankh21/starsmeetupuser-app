import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:starsmeetupuser/Apis/notificationController.dart';
import 'package:starsmeetupuser/models/notification_Model.dart';

import '../../Utilities/app_colors.dart';
import '../../Utilities/app_text_styles.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationController controller = Get.put(NotificationController());
  late Future<List<NotificationModel>> futureNotifications;
  Future<List<NotificationModel>> _loadAppointments() async {
    User? user = FirebaseAuth.instance.currentUser;
    print(user!.email!);
    return controller.getNotificationByUserId(user!.email!);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureNotifications = _loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Row(
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
                    "Notifications",
                    style: twentyTwo700TextStyle(color: purpleColor),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              // for (int i = 0; i < 7; i++)
              Container(
                child: FutureBuilder<List<NotificationModel>>(
                  future: futureNotifications,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.data!.length == 0) {
                      return Center(
                          child: Text('There is no Appointment Avaiable!'));
                    } else {
                      List<NotificationModel> notifications =
                          snapshot.data ?? [];
                      return Column(
                        children: List.generate(
                            notifications.length,
                            (index) => Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                    // border: Border.all(
                                    //   color: Colors.black,
                                    //   width: 0.7,
                                    // ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0, 0),
                                        blurRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 7),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: purpleColor),
                                          child: const Center(
                                            child: Icon(
                                              Icons.notifications_active,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "New ${notifications[index].serviceName}",
                                                    style: sixteen700TextStyle(
                                                      color: purpleColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${DateFormat('E, MMMM d').format(notifications[index].creationTimestamp!)}",
                                                    style: ten600TextStyle(
                                                        color: purpleColor),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "Your ${notifications[index].serviceName} has been schedule with ${notifications[index].celebrityName}",
                                                style: twelve400TextStyle(
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
