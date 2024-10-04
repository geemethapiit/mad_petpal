import 'package:flutter/material.dart';


class ComButton extends StatelessWidget {
  const ComButton(
      {Key? key,
        required this.width,
        required this.height,
        required this.title,
        required this.disable,
        required this.color,
        required this.onPressed})
      : super(key: key);

  final double width;
  final double height;
  final String title;
  final String color;
  final bool disable;
  final Function() onPressed;

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: _getColorFromHex(color),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )
        ),
        onPressed: disable ? null : onPressed,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}