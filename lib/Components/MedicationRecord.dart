import 'package:flutter/material.dart';
import 'package:pet_pal_project/Components/Config.dart';

class MedicationCard extends StatelessWidget {
  final String medicationID;
  final String medicationName;
  final String medicationDosage;
  final String medicationFrequency;
  final String medicationDuration;
  final String medicationNotes;
  final String medicationFileUrl;
  final VoidCallback onViewFile;

  const MedicationCard({
    Key? key,
    required this.medicationID,
    required this.medicationName,
    required this.medicationDosage,
    required this.medicationFrequency,
    required this.medicationDuration,
    required this.medicationNotes,
    required this.medicationFileUrl,
    required this.onViewFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      color: Config.backgroundColor,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildInfoRow('Medication ID:', medicationID, screenWidth, Icons.assignment),
            _buildInfoRow('Medication Name:', medicationName, screenWidth, Icons.medication),
            _buildInfoRow('Dosage:', medicationDosage, screenWidth, Icons.local_pharmacy),
            _buildInfoRow('Frequency:', medicationFrequency, screenWidth, Icons.schedule),
            _buildInfoRow('Duration:', medicationDuration, screenWidth, Icons.timer),
            _buildInfoRow('Notes:', medicationNotes, screenWidth, Icons.note),

            SizedBox(height: screenHeight * 0.02),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Config.mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    textStyle: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                  onPressed: onViewFile,
                  child: Text('View Prescription', style: TextStyle(color: Config.textColor)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, double screenWidth, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: screenWidth * 0.05, color: Config.textColor.withOpacity(0.8)),
          SizedBox(width: screenWidth * 0.02),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.04,
              color: Config.textColor.withOpacity(0.8),
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Config.textColor.withOpacity(0.8),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
