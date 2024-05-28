import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Utilities/app_colors.dart';
import '../Utilities/app_text_styles.dart';
import 'button_widget.dart';

class HolidayModeDialog extends StatefulWidget {
  final Function(DateTime?, DateTime?) onHolidayModeSelected;

  const HolidayModeDialog({Key? key, required this.onHolidayModeSelected})
      : super(key: key);

  @override
  _HolidayModeDialogState createState() => _HolidayModeDialogState();
}

class _HolidayModeDialogState extends State<HolidayModeDialog> {
  TextEditingController startingDateController = TextEditingController();
  TextEditingController endingDateController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  bool isAdded = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFieldWidgetCalendar(
              hintText: "Starting Date",
              labelText: "Date",
              textFieldController: startingDateController,
              readOnly: true,
              onTap: () {
                selectDate(context, true);
              },
              suffixIcon: const Icon(
                CupertinoIcons.calendar_today,
                color: purpleColor,
                size: 30,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFieldWidgetCalendar(
              hintText: "Ending Date",
              labelText: "Date",
              textFieldController: endingDateController,
              readOnly: true,
              onTap: () {
                selectDate(context, false);
              },
              suffixIcon: const Icon(
                CupertinoIcons.calendar_today,
                color: purpleColor,
                size: 30,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            BigButton(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 55,
              color: isAdded == false ? purpleColor : redColor,
              text: isAdded == false ? "Save" : "Remove",
              onTap: isAdded == false
                  ? () async {
                      // Save holiday
                      widget.onHolidayModeSelected(startDate, endDate);
                      setState(() {
                        isAdded = true;
                      });
                    }
                  : () async {
                      // Remove holiday
                      widget.onHolidayModeSelected(null, null);
                      setState(() {
                        isAdded = false;
                        startingDateController.clear();
                        endingDateController.clear();
                      });
                    },
              textStyle: twentyTwo700TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void selectDate(BuildContext context, bool isStartDate) async {
    DateTime? firstDate;
    DateTime? initialDate;

    if (!isStartDate && startDate != null) {
      firstDate = startDate;
      initialDate = endDate ?? startDate;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
          startingDateController.text = _formatDate(picked);
        } else {
          endDate = picked;
          endingDateController.text = _formatDate(picked);
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}

class TextFieldWidgetCalendar extends StatefulWidget {
  final String hintText;
  final String labelText;
  final TextEditingController? textFieldController;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? obscure;
  final bool? readOnly;
  final void Function()? onTap;

  const TextFieldWidgetCalendar({
    Key? key,
    required this.hintText,
    required this.labelText,
    this.textFieldController,
    this.obscure = false,
    this.readOnly = false,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
  }) : super(key: key);

  @override
  State<TextFieldWidgetCalendar> createState() =>
      _TextFieldWidgetCalendarState();
}

class _TextFieldWidgetCalendarState extends State<TextFieldWidgetCalendar> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: eighteen500TextStyle(color: Colors.black),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: widget.textFieldController,
            validator: widget.validator,
            obscureText: widget.obscure!,
            readOnly: widget.readOnly!,
            style: const TextStyle(
              color: Colors.black,
            ),
            onTap: widget.onTap,
            decoration: InputDecoration(
              suffixIcon: widget.suffixIcon,
              prefixIcon: widget.prefixIcon,
              hintStyle: TextStyle(
                color: Colors.grey[700]!,
                fontSize: 14,
              ),
              hintText: widget.hintText,
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.grey[600]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.grey[600]!,
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
        ],
      ),
    );
  }
}
