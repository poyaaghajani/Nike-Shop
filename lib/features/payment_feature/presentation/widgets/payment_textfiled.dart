import 'package:flutter/material.dart';
import 'package:nike/config/light_color.dart';

class PaymentTextfiled extends StatelessWidget {
  const PaymentTextfiled({
    super.key,
    required this.text,
    required this.keyType,
    required this.controller,
    required this.validator,
  });

  final String text;
  final TextInputType keyType;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, right: 8, left: 8),
      child: TextFormField(
        validator: validator,
        controller: controller,
        keyboardType: keyType,
        decoration: InputDecoration(
          labelText: text,
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: LightThemeColors.primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
