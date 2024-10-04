import 'package:flutter/material.dart';
import 'package:pet_pal_project/Components/Config.dart';
import 'package:pet_pal_project/Screens/Login.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Config.backgroundColor,
      body: isLandscape
          ? Row(
        children: [
          // Left side: PetPal logo and Get Started button
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              color: Config.mainColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // PetPal logo
                  Container(
                    height: screenHeight * 0.15, // Adjusted size for the logo
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('Assets/images/logo.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05), // Space between logo and button
                  // Get Started button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.07,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Config.backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Get Started',
                          style: TextStyle(fontSize: 18, color: Config.textColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right side: Welcome pet image
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('Assets/images/welcomepet.png'),
                  fit: BoxFit.cover, // The image covers the entire right side
                ),
              ),
            ),
          ),
        ],
      )
          : Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: screenHeight * 0.8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Config.mainColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 5,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Column(
                children: [
                  Config.spaceMedium(context),
                  Container(
                    height: screenHeight * 0.103,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('Assets/images/logo.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 42, top: 18),
                    child: Container(
                      height: screenHeight * 0.6,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('Assets/images/welcomepet.png'),
                          fit: BoxFit.contain,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SizedBox(
              width: double.infinity,
              height: screenHeight * 0.07,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Config.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18, color: Config.textColor),
                ),
              ),
            ),
          ),
          Config.spaceMediumNew(context),
        ],
      ),
    );
  }
}
