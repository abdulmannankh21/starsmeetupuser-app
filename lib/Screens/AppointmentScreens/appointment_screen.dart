import 'dart:developer';

import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:starsmeetupuser/Apis/historyyController.dart';
import 'package:starsmeetupuser/Screens/AppointmentScreens/upcoming_audio_appointment_details_screen.dart';
import 'package:starsmeetupuser/Screens/AppointmentScreens/upcoming_audio_history_detailsScreen.dart';
import 'package:starsmeetupuser/Screens/AppointmentScreens/upcoming_video_appointment_details_screen.dart';
import 'package:starsmeetupuser/Screens/AppointmentScreens/upcoming_video_historyScreen.dart';
import 'package:starsmeetupuser/models/historyModel.dart';

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
  var _controller = Get.put(HistoryController());
  int currentTabIndex = 0;
  String upcomingSelectedDays = 'All';
  String historySelectedStatus = 'All';
  String historySelectedDays = 'All';
  DateTime _selectedDate = DateTime.now();

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
  DateTime _selectedValue = DateTime.now();
  final AppointmentService _appointmentService = AppointmentService();
  late Future<List<AppointmentModel>> futureAppointments;
  Future<List<HistoryModel>>? futureHistory;

  Future<List<HistoryModel>> _loadHistory() async {
    User? user = FirebaseAuth.instance.currentUser;
    // print(user!.email!);
    return _appointmentService.getHistory(user!.email!);
  }

  Future<List<HistoryModel>> _loadHistoryeithCustom(
      DateTime start, DateTime end) async {
    User? user = FirebaseAuth.instance.currentUser;
    print(user!.email!);
    return _controller.getHistoryByUserIdCustomdate(user!.email!, start, end);
  }

  Future<List<AppointmentModel>> _loadAppointmentWithCustom(
      DateTime start, DateTime end) async {
    User? user = FirebaseAuth.instance.currentUser;
    print(user!.email!);
    return _appointmentService.getAppointmentsWithCustomdate(
        user!.email!, start, end);
  }

  Future<List<AppointmentModel>> _loadAppointments() async {
    User? user = FirebaseAuth.instance.currentUser;
    print(user!.email!);
    return _appointmentService.getAppointmentsByUserId(user!.email!);
  }

  Future<List<AppointmentModel>> _loadAppointmentsThisMonth() async {
    User? user = FirebaseAuth.instance.currentUser;
    print(user!.email!);
    return _appointmentService
        .getAppointmentsByUserIdCurrentMonth(user!.email!);
  }

  Future<List<HistoryModel>> _loadhistoryThisMonth() async {
    User? user = FirebaseAuth.instance.currentUser;
    print(user!.email!);
    return _controller.getAppointmentsByUserIdCurrentMonth(user!.email!);
  }

  Future<List<HistoryModel>> _loadHistoryThisYear() async {
    User? user = FirebaseAuth.instance.currentUser;
    print(user!.email!);
    return _controller.getAppointmentsByUserIdwithYear(user!.email!);
  }

  Future<List<AppointmentModel>> _loadAppointmentsThisYear() async {
    User? user = FirebaseAuth.instance.currentUser;
    print(user!.email!);
    return _appointmentService.getAppointmentsByUserIdwithYear(user!.email!);
  }

  String? Range;

  @override
  void initState() {
    super.initState();
    // Range =
    //     "${DateFormat('dd-MMM-yy').format(GetStorage().read("startDate"))} - ${DateFormat('dd-MMM-yy').format(GetStorage().read("endDate"))}" ?? "";
    _tabController = TabController(length: 2, vsync: this);
    futureAppointments = _loadAppointments().whenComplete(() {
      futureHistory = _loadHistory();
    });
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
              height: 10,
            ),
            Range != null ? Text("Date Range: ${Range}") :Text(""),
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
                  //this is 1st Tab of Tabbar
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
                            } else if (snapshot.data!.length == 0) {
                              return Center(
                                  child: Text(
                                      'There is no Appointment Avaiable!'));
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
                                    celebrityImage: appointment.celebrityImage!,
                                    onTap: () {
                                      // log("this is appointmentIndex: ${appointments[index].toJson()}");
                                      appointment.serviceName! !=
                                              "Video Meeting"
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UpcomingAudioAppointmentDetailsScreen(
                                                        appointment:
                                                            appointments[
                                                                index]),
                                              ),
                                            )
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UpcomingVideoAppointmentDetailsScreen(
                                                        appointment:
                                                            appointments[
                                                                index]),
                                              ),
                                            );
                                    },
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
                  // this is the 2nd index of Tabbar
                  Column(
                    children: [
                      Expanded(
                        child: FutureBuilder<List<HistoryModel>>(
                          future: futureHistory,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.data!.length == 0) {
                              return Center(
                                  child: Text(
                                      'There is no Appointment Avaiable!'));
                            } else {
                              List<HistoryModel> appointments =
                                  snapshot.data ?? [];
                              print(snapshot.data);
                              return ListView.builder(
                                itemCount: appointments.length,
                                itemBuilder: (context, index) {
                                  HistoryModel appointment =
                                      appointments[index];
                                  return UpcomingAppointmentWidget(
                                    name: appointment.celebrityName!,
                                    meetingType: appointment.serviceName!,
                                    celebrityImage: appointment.celebrityImage!,
                                    onTap: () {
                                      appointment.serviceName! !=
                                              "Video Meeting"
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UpComingAudioDetailsScreen(
                                                        history: appointments[
                                                            index]),
                                              ),
                                            )
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UpcomingVideoHistoryScreen(
                                                        history: appointments[
                                                            index]),
                                              ),
                                            );
                                    },
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleApplyButtonTaponHistory() {
    setState(() {
      log("this is upcoming days: ${historySelectedDays}");
      if (historySelectedDays == "This month") {
        print("this is upcoming days: ${upcomingSelectedDays}");
        futureHistory = _loadhistoryThisMonth();
      } else if (historySelectedDays == "All") {
        futureHistory = _loadHistory();
      } else if (historySelectedDays == "This year") {
        print("this is upcoming days: ${upcomingSelectedDays}");
        futureHistory = _loadHistoryThisYear();
      } else if (historySelectedDays == "Custom") {
        log("i am here");
        // pageBuilder: (_, __, ___) {
        //   return StatefulBuilder(builder: (context, setState) {
        //     return Center()}})
      }
      Navigator.pop(context);
    });
  }

  void _handleApplyButtonTap() {
    setState(() {
      if (upcomingSelectedDays == "This month") {
        print("this is upcoming days: ${upcomingSelectedDays}");
        futureAppointments = _loadAppointmentsThisMonth();
      } else if (upcomingSelectedDays == "All") {
        futureAppointments = _loadAppointments();
      } else if (upcomingSelectedDays == "This year") {
        print("this is upcoming days: ${upcomingSelectedDays}");
        futureAppointments = _loadAppointmentsThisYear();
      }
      Navigator.pop(context);
    });
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
                                if (upcomingSelectedDays == "Custom") {
                                  _selectDate(context, "upComing");
                                }
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
                              onTap: _handleApplyButtonTap,
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
                                if (historySelectedDays == "Custom") {
                                  _selectDate(context, "history");
                                }
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
                      Text(Range!),
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
                              onTap: _handleApplyButtonTaponHistory,
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

  Future<void> _selectDate(BuildContext context, String type) async {
    showCustomDateRangePicker(
      context,
      dismissible: true,
      minimumDate: DateTime.now().subtract(const Duration(days: 365)),
      maximumDate: DateTime.now().add(const Duration(days: 365)),
      endDate: DateTime.now(),
      startDate: DateTime.now().subtract(Duration(days: 7)),
      backgroundColor: Colors.white,
      primaryColor: purpleColor,
      onApplyClick: (start, end) {
        setState(() {
          log("this is the date:${start}     ${end}");
          if (start != null || end != null) {
            if (type == "upComing") {
              futureAppointments = _loadAppointmentWithCustom(start!, end!);
              // Get.back();
            } else {
              futureHistory = _loadHistoryeithCustom(start!, end!);
              //
            }
            // GetStorage().write("startDate", start);
            // GetStorage().write("endDate", end);
            setState(() {
              Range =
                  "${DateFormat('dd-MMM-yy').format(start)} / ${DateFormat('dd-MMM-yy').format(end)}";
            });
            Navigator.pop(context);
            setState(() {});
          }
          // endDate = end;
          // startDate = start;
        });
      },
      onCancelClick: () {
        setState(() {
          Navigator.pop(context);
          // endDate = null;
          // startDate = null;
        });
      },
    );

    // Navigator.pop(context);
    //
    // final pickedDateRange = await showDateRangePicker(
    //
    //   context: context,
    //   firstDate: DateTime.now().subtract(Duration(days: 365)),
    //   lastDate: DateTime.now(),
    //   initialDateRange: DateTimeRange(
    //     start: DateTime.now().subtract(Duration(days: 7)),
    //     end: DateTime.now(),
    //   ),
    // );
    //
    //
  }

// Future<void> _selectDate(BuildContext context, String type) async {
//   Navigator.pop(context);

//   final pickedDateRange = await showDateRangePicker(

//     context: context,
//     firstDate: DateTime.now().subtract(Duration(days: 365)),
//     lastDate: DateTime.now(),
//     initialDateRange: DateTimeRange(
//       start: DateTime.now().subtract(Duration(days: 7)),
//       end: DateTime.now(),
//     ),
//   );

//   if (pickedDateRange != null) {
//     print(
//         'Selected date range: ${pickedDateRange.start} this to${pickedDateRange.end}');
//     if (type == "upComing") {
//       futureAppointments = _loadAppointmentWithCustom(
//           pickedDateRange.start, pickedDateRange.end);
//       // upcomingSelectedDays = "${pickedDateRange.start} ${pickedDateRange.end}";
//       // Get.back();
//     } else {
//       futureHistory =
//           _loadHistoryeithCustom(pickedDateRange.start, pickedDateRange.end);
//       //
//     }
//     setState(() {});
//   }
// }
}
