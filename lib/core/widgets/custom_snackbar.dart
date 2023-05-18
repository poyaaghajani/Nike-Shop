import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CustomSnackbar {
  static showSnack(context, String message, Color color, Color backColor) {
    Flushbar(
      message: message,
      textDirection: TextDirection.rtl,
      messageColor: color,
      backgroundColor: backColor,
      duration: const Duration(seconds: 1),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }
}
