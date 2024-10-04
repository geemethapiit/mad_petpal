import 'package:flutter/material.dart';
import 'package:pet_pal_project/Screens/Welcome.dart';
import 'Components/BottomNavigationBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Pal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
        useMaterial3: true,
      ),
      // routes
      initialRoute: '/',
      routes: {
        // Welcome page
        '/': (context) => const WelcomePage(),
        // For main layout after login
        '/main': (context) => CustomBottomNavBar(),
      },
    );
  }
}
