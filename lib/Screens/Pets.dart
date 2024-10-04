import 'package:flutter/material.dart';
import 'package:pet_pal_project/Components/Config.dart';
import 'package:pet_pal_project/Components/ConfirmationAlert.dart';
import 'package:pet_pal_project/Components/GuideAlertMsg.dart';
import 'package:pet_pal_project/Components/PetCard.dart';
import 'package:pet_pal_project/Config/LocalStorageService.dart';
import 'package:pet_pal_project/Config/authServices.dart';
import 'package:pet_pal_project/Screens/AddNewPet.dart';
import 'package:pet_pal_project/Components/SuccessAlert.dart';
import 'package:pet_pal_project/Screens/Records.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetsPage extends StatefulWidget {
  const PetsPage({Key? key}) : super(key: key);

  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  List<dynamic> pets = [];
  bool isLoading = true;


  final LocalStorageService _localStorage = LocalStorageService();

  @override
  void initState() {
    super.initState();
    fetchPets();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchPets() async {
    try {
      final userId = await AuthServices.getIDAsInt(); // Get the user ID
      if (userId == null) {
        // Handle the case where user ID is not available
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User ID not found. Please log in again.'),
              duration: Duration(seconds: 1),
            ),
          );
        }
        return; // Exit the function if user ID is not found
      }

      // Check if the user has pets
      List<Map<String, dynamic>> petsData = await _localStorage.loadAllPetsForUser(userId.toString());

      if (mounted) {
        setState(() {
          if (petsData.isEmpty) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return GuideAlertMsg(
                  title: 'No Pets Found',
                  message: 'You have not added any pets yet. Click on the "Add Pet" button to add a new pet.',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                );
              },
            );
          } else {
            pets = petsData; // Assign the retrieved pets to the pets variable
          }
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again.'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }


  Future<void> deletePet(int petId) async {
    try {
      setState(() {
        isLoading = true;
      });
      final userId = await AuthServices.getIDAsInt();
      final response = await AuthServices.petdelete(petId);

      if (response.statusCode == 200) {
        await _localStorage.deletePet(userId.toString(), petId);
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SuccessAlert(
              message: 'Pet deleted successfully!',
              onAction: () {
                Navigator.pushNamed(context, '/main');
              },
            );
          },
        );
      } else {
        throw Exception('Failed to delete pet on server');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete pet: $e'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
    finally {
      setState(() {
        isLoading = false;
      });
    }
  }



  Future<void> _confirmDelete(int petId) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationAlert(
        message: "Do you want to remove this pet?",
        onAction: () => deletePet(petId),
        actionMessage: "Delete",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: Config.backgroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: Config.paddingBorder,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Config.spaceSmall,
                    Config.spaceSmall,
                    Row(
                      children: [
                        Icon(
                          Icons.pets,
                          size: 60,
                          color: Config.textColor,
                        ),
                        SizedBox(width: screenWidth * 0.06),
                        Text(
                          'My Pets',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Config.textColor,
                          ),
                        ),
                      ],
                    ),
                    Config.spaceMediumNew(context),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NewPet()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Config.mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.01,
                            horizontal: screenWidth * 0.1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            'Add Pet',
                            style: TextStyle(fontSize: 20,color: Config.textColor),
                          ),
                        ],
                      ),
                    ),
                    Config.spaceMediumNew(context),
                    Container(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(pets.length, (index) {
                            return SizedBox(
                              width: screenWidth * 0.85,
                              child: AnimatedBuilder(
                                animation: _controller,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _scaleAnimation.value,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.03),
                                      child: PetCard(
                                        name: pets[index]['name'],
                                        imagePath: pets[index]['pet_pic'],
                                        onRemove: () {
                                          String petIdString = pets[index]['petId'];
                                          int petId = int.parse(petIdString);
                                          _confirmDelete(petId);
                                        },
                                        onViewDetails: () {
                                          // Navigate to view details page
                                          // Pass the pet ID or details
                                        },
                                        onMedicalRecords: () {
                                          String petIdString = pets[index]['petId'];
                                          int petId = int.parse(petIdString);
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> RecordsPage(petId: petIdString,)));
                                        },
                                        onEdit: ()  {},
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    Config.spaceHigh,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
