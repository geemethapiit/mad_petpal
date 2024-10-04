import 'package:flutter/material.dart';
import 'package:pet_pal_project/Components/Config.dart';
import 'dart:io';


class PetCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final VoidCallback onRemove;
  final VoidCallback onViewDetails;
  final VoidCallback onMedicalRecords;
  final VoidCallback onEdit;

  const PetCard({
    super.key,
    required this.name,
    required this.imagePath,
    required this.onRemove,
    required this.onViewDetails,
    required this.onMedicalRecords,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Config.mainColor,
      elevation: 100,
      shadowColor: Colors.redAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: Config.paddingBorder,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                color: Colors.grey.shade200, // Fallback color for the container
              ),
              child: (imagePath.isNotEmpty && File(imagePath).existsSync())
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                ),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: const Center(
                  child: Icon(
                    Icons.pets, // Use a default pet icon
                    size: 80,
                    color: Colors.grey, // Icon color
                  ),
                ),
              ),
            ),
            Padding(
              padding: Config.paddingBorder,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Config.spaceSmall,
                          const Text(
                            'Name',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: () {
                            onEdit();
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Config.spaceSmall,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        onViewDetails();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black45,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('View Details'),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        onMedicalRecords();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black45,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Medical Records'),
                    ),
                  ),
                  Config.spaceSmall,
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        onRemove();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Remove'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
