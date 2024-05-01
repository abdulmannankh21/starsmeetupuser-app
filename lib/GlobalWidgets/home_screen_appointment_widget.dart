import 'package:flutter/material.dart';

import '../Utilities/app_colors.dart';
import '../Utilities/app_text_styles.dart';

class HomeScreenAppointmentWidget extends StatefulWidget {
  final String date;
  final int count;
  final VoidCallback onTap;
  const HomeScreenAppointmentWidget(
      {super.key,
      required this.date,
      required this.count,
      required this.onTap});

  @override
  State<HomeScreenAppointmentWidget> createState() =>
      _HomeScreenAppointmentWidgetState();
}

class _HomeScreenAppointmentWidgetState
    extends State<HomeScreenAppointmentWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        Text(
          widget.date,
          style: twenty600TextStyle(
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          children: [
            for (int i = 0; i < widget.count; i++)
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(bottom: 17),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 80,
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Faizan Azhar",
                                style: eighteen700TextStyle(
                                  color: purpleColor,
                                ),
                              ),
                              Text(
                                "09:10 PM - 09:30 PM",
                                style: fourteen400TextStyle(),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
