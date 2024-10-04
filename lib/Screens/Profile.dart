import 'package:flutter/material.dart';
import 'package:pet_pal_project/Components/Config.dart';
import 'package:pet_pal_project/Components/ConfirmationAlert.dart';
import 'package:pet_pal_project/Components/SecurityPage.dart';
import 'dart:io';
import 'package:pet_pal_project/Config/LocalStorageService.dart';
import 'package:pet_pal_project/Config/Network.dart';
import 'package:pet_pal_project/Config/authServices.dart';
import 'package:pet_pal_project/Screens/AppointmentPage.dart';
import 'package:pet_pal_project/Screens/ProfileDetails.dart';
import 'package:pet_pal_project/Screens/Settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  String _name = '';
  String _email = '';
  String? _imageUrl;
  final LocalStorageService _localStorageService = LocalStorageService();

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  void fetchProfile() async {
    try {
      final userId = await AuthServices.getID();
      if (userId != null) {
        final profileData = await _localStorageService.readProfile(userId);

        if (profileData != null) {
          setState(() {
            _name = profileData['name'] ?? 'Unknown';
            _email = profileData['email'] ?? 'Unknown';
            String? imagePath = profileData['profile_pic'];
            if (imagePath != null && imagePath.isNotEmpty) {
              _image = File(imagePath);
            }
          });
        } else {
          print('No profile data found for user ID: $userId');
        }
      }
    } catch (e) {
      print('Error reading local profile: $e');
    }
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationAlert(
          message: 'Are you sure you want to logout?',
          actionMessage: 'Logout',
          onAction: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            print('User logged out, navigating to login page.');

            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
        );
      },
    );
  }

  void _addPassword() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Config.backgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: const SecurityPage(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      decoration: BoxDecoration(
        color: Config.mainColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: isLandscape
            ? Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: screenHeight * 0.1,
                      backgroundColor: Colors.grey.shade300,
                      child: _image != null
                          ? ClipOval(
                        child: Image.file(
                          _image!,
                          width: screenWidth * 0.3,
                          height: screenHeight * 0.3,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading image from file: $error');
                            return const Icon(Icons.error, size: 100, color: Colors.red);
                          },
                        ),
                      )
                          : (_imageUrl != null
                          ? Image.network(
                        _imageUrl!,
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.3,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading image from URL: $error');
                          return const Icon(Icons.error, size: 100, color: Colors.red);
                        },
                      )
                          : const Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.grey,
                      )),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      _name,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Config.textColor),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      _email,
                      style: TextStyle(fontSize: 16, color: Config.textColor),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Config.backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Account Settings",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Config.textColor,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Expanded(
                        child: ListView(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.person),
                              title: Text("Personal Information", style: TextStyle(color: Config.textColor)),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => const ProfileDetails()));
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.schedule_outlined),
                              title: Text("My Appointments", style: TextStyle(color: Config.textColor)),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => const AppointmentPage()));
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.lock),
                              title: Text("Password & Security", style: TextStyle(color: Config.textColor)),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: _addPassword,
                            ),
                            ListTile(
                              leading: const Icon(Icons.settings),
                              title: Text("Settings", style: TextStyle(color: Config.textColor)),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => const Settings()));
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.wifi),
                              title: Text("Network", style: TextStyle(color: Config.textColor)),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => NetworkConnectivityPage()));
                              },
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            SizedBox(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.05,
                              child: ElevatedButton(
                                onPressed: _showLogoutConfirmation,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white12,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.1, vertical: screenHeight * 0.01),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text("Logout",
                                    style: TextStyle(color: Config.textColor, fontSize: 16)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
            : SingleChildScrollView(
          child: Column(
            children: [
          SizedBox(height: screenHeight * 0.05),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                "Profile",
                style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Config.textColor
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: screenWidth * 0.1),
              CircleAvatar(
                radius: screenHeight * 0.06,
                backgroundColor: Colors.grey.shade300,
                child: _image != null
                    ? ClipOval(
                  child: Image.file(
                    _image!,
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.3,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image from file: $error');
                      return const Icon(Icons.error,
                          size: 100, color: Colors.red);
                    },
                  ),
                )
                    : (_imageUrl != null
                    ? Image.network(
                  _imageUrl!,
                  width: screenWidth * 0.3,
                  height: screenHeight * 0.3,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading image from URL: $error');
                    return const Icon(Icons.error,
                        size: 100, color: Colors.red);
                  },
                )
                    : const Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.grey,
                )),
              ),
              SizedBox(width: screenWidth * 0.05),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _name,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Config.textColor
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    _email,
                    style: TextStyle(
                        fontSize: 16,
                        color: Config.textColor
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            height: screenHeight * 0.7,
            decoration: BoxDecoration(
              color: Config.backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Account Settings",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Config.textColor,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title:  Text("Personal Information", style: TextStyle(color: Config.textColor)),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const ProfileDetails()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.schedule_outlined),
                    title: Text("My Appointments", style: TextStyle(color: Config.textColor)),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const AppointmentPage()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: Text("Password & Security", style: TextStyle(color: Config.textColor)),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: _addPassword,
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: Text("Settings", style: TextStyle(color: Config.textColor)),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Settings()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.wifi),
                    title: Text("Network", style: TextStyle(color: Config.textColor)),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NetworkConnectivityPage()));
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  SizedBox(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.05,
                    child: ElevatedButton(
                      onPressed: _showLogoutConfirmation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white12,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.1,
                            vertical: screenHeight * 0.01),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child:  Text("Logout",
                          style:
                          TextStyle(color: Config.textColor, fontSize: 16)),
                    ),
                  )
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    ),
    );
  }
}

