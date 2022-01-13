import 'package:flutter/material.dart';
import 'package:time_tracker/app/components/customElevatedButton.dart';

class CustomSignInButton extends CustomElevatedButton {
  CustomSignInButton(
      {required String text,
      Color? color: Colors.white,
      Color textColor: Colors.black87,
      double borderRadius: 4.0,
      required VoidCallback? onPressed})
      : super(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.0,
                color: textColor,
              ),
            ),
            color: color,
            onPressed: onPressed,
            borderRadius: borderRadius);
}
