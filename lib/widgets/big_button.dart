import 'package:flutter/material.dart';
import 'package:pl_project/utils/constants.dart';

class BigButton extends StatelessWidget {
  final Color colour;
  final Color textColor;
  final String title;
  final VoidCallback onPressed;
  final Color borderColor;
  final FontWeight fontWeight;
  final double paddingVertival;
  final double paddingHorizontal;
  BigButton(
      {required this.title,
      this.textColor = Colors.black,
      this.colour = mainPurple,
      this.borderColor = mainPurple,
      this.fontWeight = FontWeight.bold,
      this.paddingHorizontal = 20.0,
      this.paddingVertival = 10.0,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: paddingVertival, horizontal: paddingHorizontal),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: colour,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          side: BorderSide(
            color: borderColor,
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(fontSize: 14.0, fontWeight: fontWeight),
        ),
      ),
    );
  }
}
