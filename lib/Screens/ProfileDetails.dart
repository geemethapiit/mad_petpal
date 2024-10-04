import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_pal_project/Components/CommonButton.dart';
import 'package:pet_pal_project/Components/Config.dart';
import 'package:pet_pal_project/Components/ConfirmationAlert.dart';
import 'package:pet_pal_project/Components/SuccessAlert.dart';
import 'package:pet_pal_project/Config/LocalStorageService.dart';
import 'package:pet_pal_project/Config/authServices.dart';



class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  File? _image;
  bool _isLoading = true;
  bool _isEditable = false;
  String? _imageUrl;

  final LocalStorageService _localStorageService = LocalStorageService();

  // TextEditingControllers for each field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Function to pick an image from the camera
  Future<void> _pickImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void fetchProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userIdString = await AuthServices.getID();
      final userId = userIdString ?? '';

      if (userId.isNotEmpty) {
        final response = await AuthServices.ProfileDetails();
        final apiDetails = response['data'] ?? {}; // Access the 'data' field
        final currentProfileData = await _localStorageService.readProfile(userId);

        if (currentProfileData != null) {
          bool isProfileUpdated = false;

          if ((currentProfileData['email'] ?? '') !=
              (apiDetails['email'] ?? '')) {
            currentProfileData['email'] = apiDetails['email'] as String?;
            isProfileUpdated = true;
          }

          if (isProfileUpdated) {
            await _localStorageService.saveProfile(userId, currentProfileData);
          }

          _nameController.text = currentProfileData['name'] ?? '';
          _emailController.text = currentProfileData['email'] ?? '';
          _phoneController.text = currentProfileData['phoneNo'] ?? '';
          _addressController.text = currentProfileData['address'] ?? '';

          String? imagePath = currentProfileData['profile_pic'];
          if (imagePath != null && imagePath.isNotEmpty) {
            _image = File(imagePath);
          }
        }
      }
    } catch (e) {
      print('Error fetching profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching profile')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  // Function to update profile details
  void _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    final userId = await AuthServices.getID();

    try {
      final updatedData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phoneNo': _phoneController.text,
        'address': _addressController.text,
        'profile_pic': _image?.path ?? '',
      };

      print('image path saving to local json: ${_image?.path}');
      await _localStorageService.saveProfile(userId!, updatedData);

      final result = await AuthServices.updateProfile(updatedData, _image);

      if (result == 'success') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SuccessAlert(
                  message: 'Your Profile Updated Successfully',
                  onAction: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/main');
                  });
            });
        setState(() {
          _isEditable = false;
        });
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating profile')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // delete confirmation
  Future<void> _deleteConfirmation() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConfirmationAlert(
              message: 'Are you sure you want to delete your account?',
              onAction: () => _deleteUser(),
              actionMessage: 'Delete');
        });
  }

  // delete user
  Future<void> _deleteUser() async {
    final userId = await AuthServices.getID();
    try {
      setState(() {
        _isLoading = true;
      });

      final result = await AuthServices.deleteUser();

      if (result.statusCode == 200) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SuccessAlert(
                  message: 'Your Account Deleted Successfully',
                  onAction: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/');
                  });
            });
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      print('Error deleting user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting user')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: Config.mainColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(

                )
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.05),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.02, top: screenHeight * 0.02),
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
                            SizedBox(width: screenWidth * 0.1),
                            Text(
                              "Profile Details",
                              style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Config.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Container(
                      decoration: BoxDecoration(
                        color: Config.backgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.09),
                        child: Column(
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: screenHeight * 0.09,
                                    backgroundColor: Colors.grey.shade300,
                                    child: _image != null
                                        ? ClipOval(
                                            child: Image.file(
                                              _image!,
                                              width: screenWidth * 0.38,
                                              height: screenHeight * 0.3,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                print(
                                                    'Error loading image from file: $error');
                                                return const Icon(Icons.error,
                                                    size: 100,
                                                    color: Colors.red);
                                              },
                                            ),
                                          )
                                        : (_imageUrl != null
                                            ? Image.network(
                                                _imageUrl!,
                                                width: 140,
                                                height: 140,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  print(
                                                      'Error loading image from URL: $error');
                                                  return const Icon(Icons.error,
                                                      size: 100,
                                                      color: Colors.red);
                                                },
                                              )
                                            : const Icon(
                                                Icons.person,
                                                size: 100,
                                                color: Colors.grey,
                                              )),
                                  ),
                                  SizedBox(height: screenHeight * 0.03),
                                  Container(
                                    width: screenWidth * 0.35,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.02,
                                        vertical: screenHeight * 0.01),
                                    decoration: BoxDecoration(
                                      color: Colors.white54,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          onPressed: _isEditable
                                              ? _pickImageFromCamera
                                              : null,
                                          icon: Icon(
                                            Icons.camera_alt_outlined,
                                            size: screenWidth * 0.07,
                                            color: _isEditable
                                                ? Colors.black
                                                : Colors.grey,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: _isEditable
                                              ? _pickImageFromGallery
                                              : null,
                                          icon: Icon(
                                            Icons.photo_library_outlined,
                                            size: screenWidth * 0.07,
                                            color: _isEditable
                                                ? Colors.black
                                                : Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.01),
                              child: TextField(
                                controller: _nameController,
                                enabled: _isEditable,
                                style: TextStyle(
                                  color: Config.textColor,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  labelStyle: TextStyle(
                                    color: Config.textColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Config.textColor.withOpacity(0.1),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.01),
                              child: TextField(
                                controller: _emailController,
                                enabled: _isEditable,
                                style: TextStyle(
                                  color: Config.textColor,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    color: Config.textColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Config.textColor.withOpacity(0.1),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.01),
                              child: TextField(
                                controller: _phoneController,
                                enabled: _isEditable,
                                style: TextStyle(
                                  color: Config.textColor,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Phone',
                                  labelStyle: TextStyle(
                                    color: Config.textColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Config.textColor.withOpacity(0.1),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.01),
                              child: TextField(
                                controller: _addressController,
                                enabled: _isEditable,
                                style: TextStyle(
                                  color: Config.textColor,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Address',
                                  labelStyle: TextStyle(
                                    color: Config.textColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Config.textColor.withOpacity(0.1),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            ComButton(
                              width: screenWidth * 0.6,
                              height: screenHeight * 0.05,
                              title: _isEditable ? "Save" : "Update",
                              disable: false,
                              color: "#53A39C",
                              onPressed: _isEditable
                                  ? _saveProfile
                                  : () {
                                      setState(() {
                                        _isEditable = true;
                                      });
                                    },
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            ComButton(
                              width: screenWidth * 0.6,
                              height: screenHeight * 0.05,
                              title: "Delete Account",
                              disable: false,
                              color: "#FF0000",
                              onPressed: () {
                                _deleteConfirmation();
                              },
                            ),
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
