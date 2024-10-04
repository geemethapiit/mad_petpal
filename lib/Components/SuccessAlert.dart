import 'package:flutter/material.dart';

class SuccessAlert extends StatefulWidget {
  final String message;
  final VoidCallback onAction;

  const SuccessAlert({
    super.key,
    required this.message,
    required this.onAction,
  });

  @override
  State<SuccessAlert> createState() => _SuccessAlertState();
}

class _SuccessAlertState extends State<SuccessAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 30,
          ),
          SizedBox(width: 10),
          Text(
            'Success',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      content: Text(
        widget.message,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black54,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onAction();
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            padding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'OK',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
