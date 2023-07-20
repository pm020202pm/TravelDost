import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button({Key? key, required this.buttonText, required this.textColor, required this.buttonBgColor, required this.onPressed, required this.height, required this.width, required this.borderRadius, this.splashColor}) : super(key: key);
  final String buttonText;
  final Color? textColor;
  final Color? buttonBgColor;
  final Color? splashColor;
  final VoidCallback onPressed;
  final double height;
  final double width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(borderRadius),
      color: buttonBgColor,
      child: InkWell(
        splashColor: splashColor,
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onPressed,
        child: Container(
          alignment: Alignment.center,
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Text(buttonText, style: TextStyle(color: textColor),),
        ),
      ),
    );
  }
}
