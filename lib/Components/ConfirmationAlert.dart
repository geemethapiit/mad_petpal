import 'package:flutter/material.dart';

class ConfirmationAlert extends StatefulWidget {
  final String message;
  final VoidCallback onAction;
  final String actionMessage;

  const ConfirmationAlert({
    super.key,
    required this.message,
    required this.onAction,
    required this.actionMessage,
  });

  @override
  State<ConfirmationAlert> createState() => _ConfirmationAlertState();
}

class _ConfirmationAlertState extends State<ConfirmationAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 30,
          ),
          SizedBox(width: 10),
          Text(
            'Confirm Action',
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
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black54,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Cancel",
            style: TextStyle(
              fontSize: 16,
              color: Colors.redAccent,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onAction();
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            widget.actionMessage ?? 'Yes',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
