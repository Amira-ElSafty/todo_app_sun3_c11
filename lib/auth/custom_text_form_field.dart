import 'package:flutter/material.dart';
import 'package:flutter_app_todo_sun_c11/app_colors.dart';

// typedef MyValidator = String? Function(String?);

class CustomTextFormField extends StatelessWidget {
  String label;

  String? Function(String?) validator;

  TextEditingController controller;

  TextInputType keyboardType;

  bool obscureText;

  CustomTextFormField(
      {required this.label,
      required this.validator,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
            errorMaxLines: 2,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide:
                    BorderSide(color: AppColors.primaryColor, width: 2)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.redColor, width: 2)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.redColor, width: 2)),
            labelText: label),
        validator: validator,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
      ),
    );
  }
}
