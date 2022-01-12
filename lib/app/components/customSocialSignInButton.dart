import 'package:flutter/material.dart';
import 'package:time_tracker/app/components/customElevatedButton.dart';

class CustomSocialSignInButton extends CustomElevatedButton {
  CustomSocialSignInButton(
      {required String text,
      required String assetName,
      Color? color: Colors.white,
      Color textColor: Colors.black87,
      double borderRadius: 4.0,
      required VoidCallback onPressed})
      : super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(assetName),
              Text(
                text,
                style: TextStyle(fontSize: 16.0, color: textColor),
              ),
              Opacity(
                child: Image.asset(assetName),
                opacity: 0.0,
              ),
            ],
          ),
          color: color,
          borderRadius: 4.0,
          onPressed: onPressed,
        );
}
