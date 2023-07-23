import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  const MyIconButton({Key? key, this.buttonBgColor, this.splashColor, this.iconColor, required this.onPressed, required this.iconSize, required this.height, required this.width, required this.borderRadius, required this.icon}) : super(key: key);
  final Color? buttonBgColor;
  final Color? splashColor;
  final Color? iconColor;
  final VoidCallback onPressed;
  final double iconSize;
  final double height;
  final double width;
  final double borderRadius;
  final IconData icon;
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
              borderRadius: BorderRadius.circular(borderRadius)
          ),
          child: Icon(icon, size: iconSize, color: iconColor,)),
      ),
    );
  }
}
