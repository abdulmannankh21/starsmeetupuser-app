// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../Apis/appointment_apis.dart';
import '../../Apis/time_availability_apis.dart';
import '../../GlobalWidgets/button_widget.dart';
import '../../Utilities/app_colors.dart';
import '../../Utilities/app_routes.dart';
import '../../Utilities/app_text_styles.dart';
import '../../models/appointment_model.dart';
import '../../models/time_availability_model.dart';
import 'holiday_service.dart';

class BookingCalendarScreen extends StatefulWidget {
  var data;
  BookingCalendarScreen(this.data, {super.key});

  @override
  State<BookingCalendarScreen> createState() => _BookingCalendarScreenState();
}

class _BookingCalendarScreenState extends State<BookingCalendarScreen> {
  int selectedTime = -1;
  DateTime focusedDay = DateTime.now();
  AppointmentModel? appointment;
  DateTime? selectedDay;
  DateTime? startTime;
  DateTime? endTime;
  bool isLoading = false;

  @override
  void initState() {
    assignModel();
    DateTime now = DateTime.now();
    selectedDay = DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0);
    getCurrentDaySlots(DateTime.now().weekday);
    super.initState();
  }

  List<TimeSlot>? timeSlots;
  bool isHoliday = false;

  void getCurrentDaySlots(int weekday) async {
    setState(() {
      isLoading = true;
      timeSlots = [];
      isHoliday = false;
    });

    List<AppointmentModel> dayAppointments = await AppointmentService()
        .getAppointmentsByCelebrityId(appointment!.celebrityId!);

    dayAppointments = dayAppointments
        .where((appointment) =>
            appointment.selectedDate != null &&
            appointment.selectedDate!.year == selectedDay!.year &&
            appointment.selectedDate!.month == selectedDay!.month &&
            appointment.selectedDate!.day == selectedDay!.day)
        .toList();

    List<TimeSlot> allTimeSlots = await TimeAvailabilityService()
        .getTimeAvailableForDay(
            appointment!.celebrityId!, weekdayToString(weekday));

    // Check if the selected day is a holiday
    isHoliday = await HolidayService()
        .isHoliday(selectedDay!, appointment!.celebrityId!);

    if (isHoliday) {
      setState(() {
        timeSlots = [];
        isLoading = false;
        this.isHoliday = true;
      });
    } else {
      List<TimeSlot> availableTimeSlots = allTimeSlots.where((slot) {
        return !dayAppointments
            .any((appointment) => appointment.timeSlotId == slot.id);
      }).toList();

      setState(() {
        timeSlots = availableTimeSlots;
        isLoading = false;
        this.isHoliday = false;
      });
    }
  }

  String weekdayToString(int weekday) {
    switch (weekday) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "";
    }
  }

  assignModel() {
    appointment = widget.data as AppointmentModel;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  "Calendar",
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
            TableCalendar(
              focusedDay: focusedDay,
              currentDay: selectedDay,
              headerStyle: HeaderStyle(
                titleCentered: true,
                headerPadding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                titleTextStyle: eighteen700TextStyle(),
                formatButtonShowsNext: false,
                formatButtonVisible: false,
              ),
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: purpleColor,
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.white,
                ),
                outsideDaysVisible: false,
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: fourteen600TextStyle(),
                weekendStyle: fourteen600TextStyle(),
              ),
              onDaySelected: (selected, focused) {
                print("selected");
                // Show loader when data fetching starts
                setState(() {
                  selectedTime = -1;
                  selectedDay = selected;
                  focusedDay = selected;
                });

                getCurrentDaySlots(
                    selected.weekday); // Wait for data fetching to complete

                // Hide loader when data fetching completes
              },
              daysOfWeekHeight: 30,
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(
                const Duration(days: 3650),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Text(
                "Time Availability",
                style: twentyTwo700TextStyle(color: purpleColor),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (isHoliday)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Time slots are not available for this date.",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            else if (isLoading)
              const Expanded(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoActivityIndicator(
                        radius: 15.0,
                        color: purpleColor,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Loading please wait...',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (timeSlots!.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Time slots are not available for this date.",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          runSpacing: 10.0,
                          spacing: 10.0,
                          children: [
                            for (int i = 0; i < timeSlots!.length; i++)
                              Container(
                                width: MediaQuery.of(context).size.width * 0.28,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: selectedTime == i
                                      ? purpleColor
                                      : Colors.grey[600],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    if (selectedTime != i) {
                                      selectedTime = i;
                                      startTime = convertTimeStringToDateTime(
                                          selectedDay!.year,
                                          selectedDay!.month,
                                          selectedDay!.day,
                                          timeSlots![i].startTime);
                                      endTime = convertTimeStringToDateTime(
                                          selectedDay!.year,
                                          selectedDay!.month,
                                          selectedDay!.day,
                                          timeSlots![i].endTime);
                                      appointment!.timeSlotId =
                                          timeSlots![i].id;
                                    } else {
                                      selectedTime = -1;
                                      startTime = null;
                                      endTime = null;
                                    }

                                    setState(() {});
                                  },
                                  child: Center(
                                    child: Text(
                                      timeSlots![i].startTime,
                                      style: sixteen600TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            BigButton(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 55,
              color: purpleColor,
              text: "Proceed to Checkout",
              onTap: () {
                if (selectedTime != -1) {
                  appointment!.selectedDate = selectedDay;
                  appointment!.startTime = startTime;
                  appointment!.endTime = endTime;
                  Navigator.pushNamed(context, checkoutScreenRoute,
                      arguments: appointment);
                } else {
                  EasyLoading.showError("Please select a time slot!");
                }
              },
              textStyle: twentyTwo700TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

DateTime convertTimeStringToDateTime(
    int year, int month, int day, String timeString) {
  final components = timeString.split(' ');
  final timeComponents = components[0].split(':');
  var hour = int.parse(timeComponents[0]);
  final minute = int.parse(timeComponents[1]);
  final period = components[1];

  // Adjust hour for PM period
  if (period == 'PM' && hour != 12) {
    hour += 12;
  }

  return DateTime(year, month, day, hour, minute);
}
