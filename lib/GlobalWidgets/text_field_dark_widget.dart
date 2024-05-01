import 'package:flutter/material.dart';

import '../Utilities/app_text_styles.dart';

class TextFieldDarkWidget extends StatefulWidget {
  final String hintText;
  final String labelText;
  final TextEditingController? textFieldController;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? obscure;
  final bool? readOnly;
  final void Function(String)? onChanged;

  const TextFieldDarkWidget(
      {Key? key,
      required this.hintText,
      required this.labelText,
      this.textFieldController,
      this.obscure = false,
      this.readOnly = false,
      this.validator,
      this.suffixIcon,
      this.prefixIcon,
      this.onChanged})
      : super(key: key);

  @override
  State<TextFieldDarkWidget> createState() => _TextFieldDarkWidgetState();
}

class _TextFieldDarkWidgetState extends State<TextFieldDarkWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.key,
      child: SingleChildScrollView(
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
              onChanged: (value) {
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              },
              controller: widget.textFieldController,
              validator: widget.validator,
              obscureText: widget.obscure!,
              readOnly: widget.readOnly!,
              style: const TextStyle(
                color: Colors.black,
              ),
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
      ),
    );
  }
}
