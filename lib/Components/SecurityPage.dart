import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pet_pal_project/Components/CommonButton.dart';
import 'package:pet_pal_project/Components/Config.dart';
import 'package:pet_pal_project/Components/ErrorAlert.dart';
import 'package:pet_pal_project/Components/SuccessAlert.dart';
import 'package:pet_pal_project/Config/authServices.dart';
import 'package:pet_pal_project/Config/global.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> updatePassword() async {
    if (currentPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorAlert(
            message: 'Please fill all the fields',
            onAction: () {
              Navigator.pop(context);
            },
          );
        },
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorAlert(
            message: 'New Password and Confirm Password do not match',
            onAction: () {
              Navigator.pop(context);
            },
          );
        },
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      // Send the API request
      http.Response response = await AuthServices.changePassword(
        currentPasswordController.text,
        newPasswordController.text,
        confirmPasswordController.text,
      );

      print('API Response: ${response.body}');

      // Parse the response body
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SuccessAlert(
              message: 'Your Password Changed Successfully',
              onAction: () {
                Navigator.pop(context);
              },
            );
          },
        );
      } else if (response.statusCode == 401 && responseData['status'] == false) {
        // Handle validation errors and other errors
        String errorMessage = '';

        if (responseData['errors'] != null) {
          // Concatenate all error messages
          responseData['errors'].forEach((key, value) {
            errorMessage += '${value.join(", ")}\n';
          });
        } else if (responseData['message'] != null) {
          errorMessage = responseData['message'];
        }

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ErrorAlert(
              message: errorMessage.trim(),
              onAction: () {
                Navigator.pop(context);
              },
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ErrorAlert(
              message: 'Failed to change password.',
              onAction: () {
                Navigator.pop(context);
              },
            );
          },
        );
      }
    } catch (e) {
      print('Error change password: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to change password')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(

            )
          )
        : Form(
            key: formKey,
            child: Padding(
              padding: Config.paddingBorder,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.005,
                    color: Config.textColor,
                  ),
                  SizedBox(height: screenHeight * 0.085),
                  Text(
                    "Add Your New Password",
                    style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Config.mainColor),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  TextFormField(
                    controller: currentPasswordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    cursorColor: Config.petPrimaryColor,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      prefixIcon: Icon(Icons.lock_outline), // Changed Icon
                      prefixIconColor: Config.mainColor,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your current password';
                      }
                      return null;
                    },
                  ),
                  Config.spaceSmall,
                  TextFormField(
                    controller: newPasswordController,
                    keyboardType: TextInputType.text,
                    obscureText: true, // This is important for passwords
                    cursorColor: Config.petPrimaryColor,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      prefixIcon: Icon(Icons.vpn_key), // Changed Icon
                      prefixIconColor: Config.mainColor,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your New Password';
                      }
                      return null;
                    },
                  ),
                  Config.spaceSmall,
                  TextFormField(
                    controller: confirmPasswordController,
                    keyboardType: TextInputType.text,
                    obscureText: true, // Again, for password fields
                    cursorColor: Config.petPrimaryColor,
                    decoration:  InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.verified_user), // Changed Icon
                      prefixIconColor: Config.mainColor,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Confirm Password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  ComButton(
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.05,
                    title: 'Submit',
                    disable: false,
                    color: '#53A39C',
                    onPressed: () {
                      updatePassword();
                    },
                  ),
                  SizedBox(height: screenHeight * 0.09),
                ],
              ),
            ),
          );
  }
}
