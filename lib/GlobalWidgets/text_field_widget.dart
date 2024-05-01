import 'package:flutter/material.dart';

import '../Utilities/app_text_styles.dart';

class TextFieldWidget extends StatefulWidget {
  final String hintText;
  final String labelText;
  final TextEditingController? textFieldController;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? isEnrollAsStar;
  final bool obscureText;
  final int? maxCharacters;
  final void Function(String)? onChanged;
  final GlobalKey<FormState>? formKey; // Add this property

  const TextFieldWidget({
    Key? key,
    required this.hintText,
    required this.labelText,
    this.textFieldController,
    this.validator,
    this.suffixIcon,
    required this.obscureText,
    this.formKey,
    this.prefixIcon,
    this.isEnrollAsStar = false,
    this.maxCharacters,
    this.onChanged,
  }) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: eighteen600TextStyle(
                color: widget.isEnrollAsStar == true
                    ? Colors.white
                    : Colors.black),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: widget.textFieldController,
            validator: widget.validator,
            onChanged: (value) {
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            style: TextStyle(
              fontSize: 15.0,
              color:
                  widget.isEnrollAsStar == true ? Colors.white : Colors.black,
            ),
            obscureText: widget.obscureText,
            maxLength: widget.maxCharacters,
            decoration: InputDecoration(
              suffixIcon: widget.suffixIcon,
              counterText: "",
              prefixIcon: widget.prefixIcon,
              hintStyle: TextStyle(
                fontSize: 15.0,
                color: widget.isEnrollAsStar == true
                    ? Colors.white
                    : Colors.grey[600]!,
                fontWeight: FontWeight.w500,
              ),
              hintText: widget.hintText,
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: widget.isEnrollAsStar == true
                      ? Colors.white
                      : Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Colors.black,
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
