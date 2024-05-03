import 'package:flutter/material.dart';
import 'package:starsmeetupuser/models/historyModel.dart';

class UpcomingVideoHistoryScreen extends StatefulWidget {
  HistoryModel history = HistoryModel();

  UpcomingVideoHistoryScreen({super.key, required this.history});

  @override
  State<UpcomingVideoHistoryScreen> createState() =>
      _UpcomingVideoHistoryScreenState();
}

class _UpcomingVideoHistoryScreenState
    extends State<UpcomingVideoHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
