import 'package:flutter/material.dart';
import 'package:pet_pal_project/Components/CommonButton.dart';
import 'package:pet_pal_project/Components/Config.dart';


class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return isLoading
        ? const Center(
      child: CircularProgressIndicator()
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
              color: Colors.black,
            ),
            SizedBox(height: screenHeight * 0.085),
            Text(
              "Forgot Password",
              style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            SizedBox(height: screenHeight * 0.05),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.text,
              obscureText: true,
              cursorColor: Config.petSupportingColor,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email), // Changed Icon
                prefixIconColor: Config.petSupportingColor,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
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
              color: '#512DA8',
              onPressed: () {

              },
            ),
            SizedBox(height: screenHeight * 0.09),
          ],
        ),
      ),
    );
  }
}
