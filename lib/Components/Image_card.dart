import 'package:flutter/material.dart';
class ImageCard extends StatelessWidget {
  const ImageCard({Key? key, required this.height, required this.width, required this.radius, required this.imageProvider}) : super(key: key);
  final double height;
  final double width;
  final double radius;
  final ImageProvider imageProvider;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
            image:imageProvider,
            fit: BoxFit.cover),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
