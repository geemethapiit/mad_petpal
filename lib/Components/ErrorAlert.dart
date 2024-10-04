import 'package:flutter/material.dart';

class ErrorAlert extends StatefulWidget {
  final String message;
  final VoidCallback onAction;
  final bool showAction; // Add this parameter

  const ErrorAlert({
    super.key,
    required this.message,
    required this.onAction,
    this.showAction = true, // Default to true
  });

  @override
  State<ErrorAlert> createState() => _ErrorAlertState();
}

class _ErrorAlertState extends State<ErrorAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Row(
        children: [
          Icon(
            Icons.error,
            color: Colors.red,
            size: 30,
          ),
          SizedBox(width: 10),
          Text(
            'Error',
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
      actions: widget.showAction // Conditionally show actions
          ? [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onAction();
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
      ]
          : [],
    );
  }
}
