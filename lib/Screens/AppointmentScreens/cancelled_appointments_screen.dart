import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Apis/appointment_apis.dart';
import '../../GlobalWidgets/button_widget.dart';
import '../../GlobalWidgets/upcoming_appointment_widget.dart';
import '../../Utilities/app_colors.dart';
import '../../Utilities/app_routes.dart';
import '../../Utilities/app_text_styles.dart';
import '../../models/appointment_model.dart';

class CancelledAppointmentScreen extends StatefulWidget {
  const CancelledAppointmentScreen({super.key});

  @override
  State<CancelledAppointmentScreen> createState() =>
      _CancelledAppointmentScreenState();
}

class _CancelledAppointmentScreenState
    extends State<CancelledAppointmentScreen> {
  // String _selectedItem = 'Option 1';

  // final List<String> _options = [
  //   'Option 1',
  //   'Option 2',
  //   'Option 3',
  //   'Option 4'
  // ];
  final AppointmentService _appointmentService = AppointmentService();

  late Future<List<AppointmentModel>> cancelAppointments;
  Future<List<AppointmentModel>> _loadCancelledAppointments() async {
    User? user = FirebaseAuth.instance.currentUser;
    print(user!.email!);
    return _appointmentService.getAppointmentsByStatus(user!.email!,"Cancelled");
  }
  @override
  void initState() {
    // TODO: implement initState
    cancelAppointments = _loadCancelledAppointments();
    super.initState();
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
                  "Cancelled Appointments",
                  style: twentyTwo700TextStyle(color: purpleColor),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: GestureDetector(
            //     onTap: () {
            //       showCancelledPopUp(context);
            //     },
            //     child: Container(
            //       width: 30,
            //       height: 30,
            //       decoration: BoxDecoration(
            //         border: Border.all(
            //           color: Colors.grey,
            //         ),
            //         borderRadius: BorderRadius.circular(5.0),
            //       ),
            //       child: Center(
            //         child: Image.asset(
            //           "assets/filterIcon.png",
            //           width: 20,
            //           height: 20,
            //           color: purpleColor,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              child: FutureBuilder<List<AppointmentModel>>(
                future: cancelAppointments,
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
                        return CancelledAppointmentWidget(
                          name: appointment.celebrityName!,
                          meetingType: appointment.serviceName!,
                          celebrityImage: appointment.celebrityImage!,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, cancelledAppointmentDetailsScreenRoute);
                            }
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
      ),
    );
  }

  // showCancelledPopUp(pageContext) {
  //   showGeneralDialog(
  //     context: pageContext,
  //     barrierLabel: "Barrier",
  //     transitionDuration: const Duration(seconds: 0),
  //     barrierDismissible: true,
  //     pageBuilder: (_, __, ___) {
  //       return StatefulBuilder(builder: (context, setState) {
  //         return Center(
  //           child: Material(
  //             color: Colors.transparent,
  //             child: Container(
  //               margin: const EdgeInsets.symmetric(horizontal: 20),
  //               width: MediaQuery.of(pageContext).size.width,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(15),
  //                 color: Colors.white,
  //               ),
  //               padding: const EdgeInsets.all(10.0),
  //               child: SizedBox(
  //                 height: 250,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     const SizedBox(
  //                       height: 20,
  //                     ),
  //                     Align(
  //                       alignment: Alignment.centerLeft,
  //                       child: Text(
  //                         "Filter",
  //                         style: twentyFive700TextStyle(color: purpleColor),
  //                         textAlign: TextAlign.center,
  //                       ),
  //                     ),
  //                     Text(
  //                       "Status",
  //                       style: eighteen700TextStyle(color: purpleColor),
  //                       textAlign: TextAlign.center,
  //                     ),
  //                     const SizedBox(
  //                       height: 10,
  //                     ),
  //                     Container(
  //                       width: MediaQuery.of(context).size.width * 0.8,
  //                       height: 50,
  //                       decoration: BoxDecoration(
  //                         border: Border.all(
  //                           color: Colors.black,
  //                           width: 0.7,
  //                         ),
  //                         borderRadius: BorderRadius.circular(10.0),
  //                       ),
  //                       padding: const EdgeInsets.symmetric(horizontal: 10),
  //                       child: DropdownButtonHideUnderline(
  //                         child: DropdownButton<String>(
  //                           padding: EdgeInsets.zero,
  //                           isExpanded: true,
  //                           value: _selectedItem,
  //                           onChanged: (String? newValue) {
  //                             setState(() {
  //                               _selectedItem = newValue!;
  //                             });
  //                           },
  //                           items: _options
  //                               .map<DropdownMenuItem<String>>((String value) {
  //                             return DropdownMenuItem<String>(
  //                               value: value,
  //                               child: Text(value),
  //                             );
  //                           }).toList(),
  //                           style: eighteen500TextStyle(
  //                             color: Colors.black,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(
  //                       height: 40,
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.symmetric(horizontal: 20),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           const SizedBox(
  //                             width: 1,
  //                           ),
  //                           Text(
  //                             "Cancel",
  //                             style: eighteen600TextStyle(
  //                               color: purpleColor,
  //                             ),
  //                           ),
  //                           BigButton(
  //                             width:
  //                                 MediaQuery.of(pageContext).size.width * 0.4,
  //                             height: 45,
  //                             color: purpleColor,
  //                             text: "Apply",
  //                             onTap: () {
  //                               Navigator.pop(pageContext);
  //                             },
  //                             borderRadius: 5.0,
  //                             textStyle:
  //                                 eighteen700TextStyle(color: Colors.white),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }
}
