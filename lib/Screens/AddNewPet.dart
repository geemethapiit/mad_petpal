import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_pal_project/Components/Config.dart';
import 'package:pet_pal_project/Components/ErrorAlert.dart';
import 'package:pet_pal_project/Components/SuccessAlert.dart';
import 'package:pet_pal_project/Config/LocalStorageService.dart';
import 'package:pet_pal_project/Config/authServices.dart';

class NewPet extends StatefulWidget {
  const NewPet({super.key});

  @override
  State<NewPet> createState() => _NewPetState();
}

class _NewPetState extends State<NewPet> {
  final formKey = GlobalKey<FormState>();
  final registration_number = TextEditingController();
  final name = TextEditingController();
  final type = TextEditingController();
  final breed = TextEditingController();
  final age = TextEditingController();
  final color = TextEditingController();
  final special_notes = TextEditingController();
  String _selectedGender = '';

  @override
  void dispose() {
    registration_number.dispose();
    name.dispose();
    type.dispose();
    breed.dispose();
    age.dispose();
    color.dispose();
    special_notes.dispose();
    super.dispose();
  }

  final LocalStorageService _localStorageService = LocalStorageService();

  bool isLoading = false;
  XFile? image; // Image file

  // Create a new pet
  Future<void> createPet() async {
    if (formKey.currentState!.validate()) {
      String _registration_number = registration_number.text;
      String _name = name.text;
      String _type = type.text;
      String _breed = breed.text;
      String _age = age.text;
      String _color = color.text;

      // Ensure that required fields are not empty
      if (_registration_number.isEmpty || _name.isEmpty || _type.isEmpty || _breed.isEmpty || _age.isEmpty || _color.isEmpty || _selectedGender.isEmpty) {
        errorSnackBar(context, 'Enter all required fields');
        return;
      }

      try {
        setState(() {
          isLoading = true;
        });

        // Prepare data to send to the API
        final savedData = {
          'registration_number': _registration_number,
          'name': _name,
          'type': _type,
          'breed': _breed,
          'age': _age,
          'color': _color,
          'gender': _selectedGender,
          'pet_pic': vehicle_image?.path ?? '',
        };

        // Send data to the API
        final result = await AuthServices.petregister(savedData, vehicle_image);

        if (result['status'] == 'success') {
          int  petId = result['pet_id'];
          final userId = await AuthServices.getID();

          try {
            await _localStorageService.savePet(userId!, petId, savedData);
            print('Pet data saved locally');

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return SuccessAlert(
                  message: "Pet Created Successfully",
                  onAction: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, '/main');
                  },
                );
              },
            );
          } catch (localError) {
            print('Local storage saving error: $localError');
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ErrorAlert(
                  message: 'Failed to save pet data locally. Please try again.',
                  onAction: () => Navigator.of(context).pop(),
                );
              },
            );
          }
        } else {
          errorSnackBar(context, 'Failed to create pet. Please try again.');
        }
      } catch (e) {
        print('Error: $e'); // Debugging
        errorSnackBar(context, 'An error occurred. Please try again.');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }


  void showSuccessAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 30,
              ),
              SizedBox(width: 10),
              Text(
                'Success',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: const Text(
            'Your pet has been successfully created!',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/main');
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
          ],
        );
      },
    );
  }

  void errorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  File? vehicle_image;
  String? _imageUrl;

  // Function to pick an image from the camera
  Future<void> _pickImageFromCamera() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        vehicle_image = File(pickedFile.path);
      });
    }
  }

  // Function to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        vehicle_image = File(pickedFile.path);
      });
    }
  }

  // Method to remove the selected image
  void _removeImage() {
    setState(() {
      vehicle_image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get the screen height
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration:  BoxDecoration(
        color: Config.mainColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: Config.paddingBorder,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Config.backgroundColor.withOpacity(0.5),
                        ),
                        child: IconButton(
                          icon:
                              Icon(Icons.arrow_back, color: Config.textColor ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.08),
                      Text(
                        'Add Your Pet',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Config.backgroundColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Config.spaceMediumNew(context),
                Container(
                  decoration:BoxDecoration(
                    color: Config.backgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Form(
                    key: formKey, // Apply the formKey here
                    child: Padding(
                      padding: const EdgeInsets.all(50),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: screenHeight * 0.08,
                            backgroundColor: Colors.grey.shade300,
                            child: vehicle_image != null
                                ? ClipOval(
                              child: Image.file(
                                vehicle_image!,
                                width: screenWidth * 0.38,
                                height: screenHeight * 0.3,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  print(
                                      'Error loading image from file: $error');
                                  return Icon(Icons.error,
                                      size: screenHeight * 0.1,
                                      color: Colors.red);
                                },
                              ),
                            )
                                : (_imageUrl != null
                                ? Image.network(
                              _imageUrl!,
                              width: screenWidth * 0.38,
                              height: screenHeight * 0.3,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print(
                                    'Error loading image from URL: $error');
                                return Icon(Icons.error,
                                    size: screenHeight * 0.1,
                                    color: Colors.red);
                              },
                            )
                                : Icon(
                              Icons.pets,
                              size: screenHeight * 0.1,
                              color: Colors.grey,
                            )),
                          ),
                          Config.spaceMediumNew(context),
                          Container(
                            width: screenWidth * 0.4,
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02,
                                vertical: screenHeight * 0.01),
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: _pickImageFromCamera,
                                  icon: Icon(
                                    Icons.camera_alt_outlined,
                                    size: screenWidth * 0.07,
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _pickImageFromGallery,
                                  icon: Icon(
                                    Icons.photo_library_outlined,
                                    size: screenWidth * 0.07,
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                    onPressed: _removeImage,
                                    icon: Icon(Icons.delete,
                                        size: screenWidth * 0.07,
                                        color: Colors.red)),
                              ],
                            ),
                          ),
                          Config.spaceMediumNew(context),
                          TextFormField(
                            controller: registration_number,
                            decoration: InputDecoration(
                              labelText: 'Registration No',
                              labelStyle: const TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                                horizontal: screenWidth * 0.05,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter registration number';
                              }
                              return null;
                            },
                          ),
                          Config.spaceMediumNew(context),
                          TextFormField(
                            controller: name,
                            decoration: InputDecoration(
                              labelText: 'Pet Name',
                              labelStyle: const TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                                horizontal: screenWidth * 0.05,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter pet name';
                              }
                              return null;
                            },
                          ),
                          Config.spaceMediumNew(context),
                          TextFormField(
                            controller: type,
                            decoration: InputDecoration(
                              labelText: 'Pet Type',
                              labelStyle: const TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                                horizontal: screenWidth * 0.05,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter pet type';
                              }
                              return null;
                            },
                          ),
                          Config.spaceMediumNew(context),
                          TextFormField(
                            controller: breed,
                            decoration: InputDecoration(
                              labelText: 'Pet Breed',
                              labelStyle: const TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                                horizontal: screenWidth * 0.05,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter pet breed';
                              }
                              return null;
                            },
                          ),
                          Config.spaceMediumNew(context),
                          TextFormField(
                            controller: age,
                            decoration: InputDecoration(
                              labelText: 'Pet Age',
                              labelStyle: const TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                                horizontal: screenWidth * 0.05,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter pet age';
                              }
                              return null;
                            },
                          ),
                          Config.spaceMediumNew(context),
                          TextFormField(
                            controller: color,
                            decoration: InputDecoration(
                              labelText: 'Pet Color',
                              labelStyle: const TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                                horizontal: screenWidth * 0.05,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter pet color';
                              }
                              return null;
                            },
                          ),
                          Config.spaceMediumNew(context),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Gender',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text("Male"),
                                  value: "Male",
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text("Female"),
                                  value: "Female",
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Config.spaceMediumNew(context),
                          TextFormField(
                            controller: special_notes,
                            maxLines: 2,
                            decoration: InputDecoration(
                              labelText: 'Special Notes',
                              labelStyle: const TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                                horizontal: screenWidth * 0.05,
                              ),
                            ),
                          ),
                          Config.spaceMediumNew(context),
                          SizedBox(
                            width: screenWidth * 0.8,
                            height: screenHeight * 0.05,
                            child: ElevatedButton(
                              onPressed: () {
                                createPet(); // Call the createPet method here
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Config.petSupportingColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )
                                  : const Text(
                                      'Submit',
                                      style: TextStyle(fontSize: 20),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
