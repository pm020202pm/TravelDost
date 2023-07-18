import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button({Key? key, required this.buttonText, required this.textColor, required this.buttonBgColor, required this.onPressed, required this.height, required this.width}) : super(key: key);
  final String buttonText;
  final Color? textColor;
  final Color? buttonBgColor;
  final VoidCallback onPressed;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: buttonBgColor,
      ),
      child: TextButton(
          onPressed: onPressed,
          child: Text(buttonText, style: TextStyle(color: textColor),)
      ),
    );
  }
}
