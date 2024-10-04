import 'package:flutter/material.dart';
import 'package:pet_pal_project/Components/Config.dart';


class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Config.mainColor,
          title:  Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: Text(
              "Notification",
              style: TextStyle(
                color: Config.textColor,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
    );
  }
}
