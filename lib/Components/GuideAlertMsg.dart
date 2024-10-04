import 'package:flutter/material.dart';

class GuideAlertMsg extends StatefulWidget {
  final String? title;
  final String? message;
  final Function? onPressed;

  const GuideAlertMsg({
    super.key,
    this.title,
    this.message,
    this.onPressed,
  });

  @override
  State<GuideAlertMsg> createState() => _GuideAlertMsgState();
}

class _GuideAlertMsgState extends State<GuideAlertMsg> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners for the AlertDialog
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Use only as much vertical space as needed
          children: [
            Container(
              height: screenHeight * 0.2,
              width: screenWidth,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('Assets/images/loginPet.jpg'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              width: screenWidth,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Text(
                    widget.title ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.message ?? 'No Message',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.onPressed != null) {
                        widget.onPressed!();
                      } else {
                        Navigator.pop(context); // Close the alert dialog
                      }
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
