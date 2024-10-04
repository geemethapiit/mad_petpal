import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Ensure you have this package added
import 'package:pet_pal_project/Components/Config.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Color pickedBackgroundColor = Config.backgroundColor;
  Color pickedMainColor = Config.mainColor;
  Color pickedTextColor = Config.textColor;

  Widget _buildColorPickerRow({
    required String title,
    required Color color,
    required ValueChanged<Color> onColorChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: pickedTextColor),
        ),
        GestureDetector(
          onTap: () {
            _pickColor(color, onColorChanged);
          },
          child: Container(
            width: 50, // Width of the color box
            height: 50, // Height of the color box
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.black, width: 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDarkModeToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Dark Mode:', style: TextStyle(color: pickedTextColor),),
        Switch(
          value: Config.isDarkMode,
          onChanged: (value) {
            setState(() {
              Config.toggleDarkMode();
              // Update the colors based on the selected theme
              pickedBackgroundColor = Config.backgroundColor;
              pickedMainColor = Config.mainColor;
              pickedTextColor = Config.textColor;
            });
          },
        ),
      ],
    );
  }

  void _pickColor(
      Color currentColor, ValueChanged<Color> onColorChanged) async {
    Color pickedColor = currentColor; // Set initial color
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickedColor,
              onColorChanged: (Color color) {
                pickedColor = color;
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Select'),
              onPressed: () {
                onColorChanged(pickedColor); // Update the color
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: pickedMainColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Config.spaceMediumNew(context),
              Padding(
                padding: Config.paddingBorder,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black54,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.08),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Config.spaceMediumNew(context),
              Container(
                height: screenHeight * 0.9,
                decoration: BoxDecoration(
                  color: Config.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: Config.paddingBorder,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildColorPickerRow(
                        title: 'Background Color:',
                        color: pickedBackgroundColor,
                        onColorChanged: (color) {
                          setState(() {
                            Config.backgroundColor = color;
                            pickedBackgroundColor = color;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildColorPickerRow(
                        title: 'Main Color:',
                        color: pickedMainColor,
                        onColorChanged: (color) {
                          setState(() {
                            Config.mainColor = color;
                            pickedMainColor = color;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildColorPickerRow(
                        title: 'Text Color:',
                        color: pickedTextColor,
                        onColorChanged: (color) {
                          setState(() {
                            Config.textColor = color;
                            pickedTextColor = color;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildDarkModeToggle(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
