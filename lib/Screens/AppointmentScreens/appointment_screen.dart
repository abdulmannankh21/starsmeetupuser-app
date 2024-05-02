import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starsmeetupuser/Screens/AppointmentScreens/upcoming_audio_appointment_details_screen.dart';
import 'package:starsmeetupuser/Screens/AppointmentScreens/upcoming_video_appointment_details_screen.dart';

import '../../Apis/appointment_apis.dart';
import '../../GlobalWidgets/button_widget.dart';
import '../../GlobalWidgets/upcoming_appointment_widget.dart';
import '../../Utilities/app_colors.dart';
import '../../Utilities/app_routes.dart';
import '../../Utilities/app_text_styles.dart';
import '../../models/appointment_model.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentTabIndex = 0;
  String upcomingSelectedDays = 'All';
  String historySelectedStatus = 'All';
  String historySelectedDays = 'All';

  final List<String> historyStatus = [
    'All',
    'Completed',
    'No Show',
  ];

  final List<String> historyDays = [
    'All',
    'This month',
    'This year',
    'Custom',
  ];
  final List<String> upcomingDays = [
    'All',
    'This month',
    'This year',
    'Custom',
  ];
  final AppointmentService _appointmentService = AppointmentService();
  late Future<List<AppointmentModel>> futureAppointments;
  late Future<List<AppointmentModel>> historyAppointments;

  Future<List<AppointmentModel>> _loadAppointments() async {
    User? user = FirebaseAuth.instance.currentUser;
    print(user!.email!);
    return _appointmentService.getAppointmentsByUserId(user!.email!);

  }
  Future<List<AppointmentModel>> _loadHistoryAppointments() async {
    User? user = FirebaseAuth.instance.currentUser;
    print(user!.email!);
    return _appointmentService.getAppointmentsByUserIdAndDate(user!.email!);

  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    futureAppointments = _loadAppointments();
    historyAppointments = _loadHistoryAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
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
                  "Appointments",
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
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "Upcoming"),
                  Tab(text: "History"),
                ],
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelStyle: eighteen600TextStyle(
                  color: Colors.grey,
                ),
                labelStyle: eighteen700TextStyle(
                  color: Colors.white,
                ),
                onTap: (a) {
                  currentTabIndex = a;
                  setState(() {});
                },
                unselectedLabelColor: Colors.grey[600],
                indicator: ShapeDecoration(
                  color: purpleColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(currentTabIndex == 0 ? 5 : 0),
                      topRight: Radius.circular(currentTabIndex == 0 ? 0 : 5),
                      bottomLeft: Radius.circular(currentTabIndex == 0 ? 5 : 0),
                      bottomRight:
                          Radius.circular(currentTabIndex == 0 ? 0 : 5),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  currentTabIndex == 0
                      ? showUpcomingPopUp(context)
                      : showHistoryPopUp(context);
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/filterIcon.png",
                      width: 20,
                      height: 20,
                      color: purpleColor,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                   Column(
                    children: [

                      Expanded(
                        child: FutureBuilder<List<AppointmentModel>>(
                          future: futureAppointments,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              List<AppointmentModel> appointments =
                                  snapshot.data ?? [];
                              print(snapshot.data);
                              return ListView.builder(
                                itemCount: appointments.length,
                                itemBuilder: (context, index) {
                                  AppointmentModel appointment =
                                      appointments[index];
                                  return UpcomingAppointmentWidget(
                                    name: appointment.celebrityName!,
                                    meetingType: appointment.serviceName!,
                                    onTap: (){
                                      appointment.serviceName! != "Video Meeting"
?
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpcomingAudioAppointmentDetailsScreen(appointment: appointment),
                                        ),
                                      ) : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpcomingVideoAppointmentDetailsScreen(appointment: appointment),
                                        ),
                                      );                                    },
                                    // Add other properties as needed
                                  );
                                },
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: FutureBuilder<List<AppointmentModel>>(
                          future: historyAppointments,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              List<AppointmentModel> appointments =
                                  snapshot.data ?? [];
                              print(snapshot.data);
                              return ListView.builder(
                                itemCount: appointments.length,
                                itemBuilder: (context, index) {
                                  AppointmentModel appointment =
                                  appointments[index];
                                  return HistoryAppointmentWidget(
                                    name: appointment.celebrityName!,
                                    meetingType: appointment.serviceName!,
                                    onTap: (){
                                       Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpcomingVideoAppointmentDetailsScreen(appointment: appointment),
                                        ),
                                      );                                    },
                                    // Add other properties as needed
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showUpcomingPopUp(pageContext) {
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
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(pageContext).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Filter",
                          style: twentyFive700TextStyle(color: purpleColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        "Days",
                        style: eighteen700TextStyle(color: purpleColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 0.7,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            padding: EdgeInsets.zero,
                            isExpanded: true,
                            value: upcomingSelectedDays,
                            onChanged: (String? newValue) {
                              setState(() {
                                upcomingSelectedDays = newValue!;
                              });
                            },
                            items: upcomingDays
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            style: eighteen500TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
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
                              "Cancel",
                              style: eighteen600TextStyle(
                                color: purpleColor,
                              ),
                            ),
                            BigButton(
                              width:
                                  MediaQuery.of(pageContext).size.width * 0.4,
                              height: 45,
                              color: purpleColor,
                              text: "Apply",
                              onTap: () {
                                Navigator.pop(pageContext);
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

  showHistoryPopUp(pageContext) {
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
                  height: 340,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Filter",
                          style: twentyFive700TextStyle(color: purpleColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        "Status",
                        style: eighteen700TextStyle(color: purpleColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 0.7,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            padding: EdgeInsets.zero,
                            isExpanded: true,
                            value: historySelectedStatus,
                            onChanged: (String? newValue) {
                              setState(() {
                                historySelectedStatus = newValue!;
                              });
                            },
                            items: historyStatus
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            style: eighteen500TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Days",
                        style: eighteen700TextStyle(color: purpleColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 0.7,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            padding: EdgeInsets.zero,
                            isExpanded: true,
                            value: historySelectedDays,
                            onChanged: (String? newValue) {
                              setState(() {
                                historySelectedDays = newValue!;
                              });
                            },
                            items: historyDays
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            style: eighteen500TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
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
                              "Cancel",
                              style: eighteen600TextStyle(
                                color: purpleColor,
                              ),
                            ),
                            BigButton(
                              width:
                                  MediaQuery.of(pageContext).size.width * 0.4,
                              height: 45,
                              color: purpleColor,
                              text: "Apply",
                              onTap: () {
                                Navigator.pop(pageContext);
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
