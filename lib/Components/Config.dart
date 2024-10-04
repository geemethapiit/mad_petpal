import 'package:flutter/material.dart';

class Config {


  static void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    backgroundColor = isDarkMode ? Colors.black : Color(0xFFFFFFFF);
    mainColor = isDarkMode ? Color(0xFF53a39c) : Color(0xFF53a39c);
    textColor = isDarkMode ? Colors.white : Colors.black;
  }

  static Color backgroundColor = Color(0xFFFFFFFF);
  static Color mainColor = Color(0xFF53a39c);
  static Color textColor = Color(0xFF000000);

  static bool isDarkMode = false;

  // Media query data and screen size initialization
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;

  // Initializes media query data and screen dimensions
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
  }

  // Convenience method to get screen width
  static double getWidthSize(BuildContext context) {
    if (_mediaQueryData == null) {
      Config.init(context);
    }
    return screenWidth!;
  }

  // Convenience method to get screen height
  static double getHeightSize(BuildContext context) {
    if (_mediaQueryData == null) {
      Config.init(context);
    }
    return screenHeight!;
  }

  // Define spacings
  static const spaceSmall = SizedBox(
    height: 25,
  );

  // These spacings are dynamically calculated based on screen height
  static SizedBox spaceMedium(BuildContext context) {
    return SizedBox(
      height: getHeightSize(context) * 0.077,
    );
  }

  static SizedBox spaceMediumNew(BuildContext context) {
    return SizedBox(
      height: getHeightSize(context) * 0.03125,
    );
  }

  static SizedBox spaceBig(BuildContext context) {
    return SizedBox(
      height: getHeightSize(context) * 0.5,
    );
  }

  static const spaceHigh = SizedBox(
    height: 130,
  );

  // TextFormField borders
  static const outlinedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  static const focusBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(
      color: Colors.black,
    ),
  );

  static const errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(
      color: Colors.red,
    ),
  );

  // Padding settings
  static const paddingBorder = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 20,
  );

  static const paddingHOnly = EdgeInsets.symmetric(horizontal: 15);

  // Primary and secondary color constants
  static const primaryColor = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xFFD66D75), // Hex color for #D66D75
        Color(0xFFE29587), // Hex color for #F6B5CC
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );


  // Primary Color
  static const petPrimaryColor = Color(0xFF48C9B0); // Soft Teal

  // Accent Color
  static const petAccentColor = Color(0xFFFF6F61); // Bright Coral

  // Neutral Color
  static const petNeutralColor = Color(0xFFF0F0F0); // Soft Gray

  // Supporting Color
  static const petSupportingColor = Color(0xFF53a39c); // Pastel Green

  static const TextStyle HeaderTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 48,
    fontWeight: FontWeight.bold,
    fontFamily: 'quicksand',
  );


  // Gradient background
  static const gradientBackground = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xFFC1E1C1),
        Color(0xFFFFFFFF),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}
