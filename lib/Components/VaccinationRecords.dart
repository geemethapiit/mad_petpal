import 'package:flutter/material.dart';
import 'package:pet_pal_project/Components/Config.dart';

class VaccinationCard extends StatelessWidget {
  final String vaccinationID;
  final String vaccineName;
  final String vaccineDate;
  final String vaccineExpiryDate;
  final String veterinarianNotes;
  final String vaccineFileUrl;
  final VoidCallback onViewFile;

  const VaccinationCard({
    Key? key,
    required this.vaccinationID,
    required this.vaccineName,
    required this.vaccineDate,
    required this.vaccineExpiryDate,
    required this.veterinarianNotes,
    required this.vaccineFileUrl,
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
            _buildInfoRow('Vaccination ID:', vaccinationID, screenWidth, Icons.assignment),
            _buildInfoRow('Vaccine Name:', vaccineName, screenWidth, Icons.medical_services),
            _buildInfoRow('Vaccination Date:', vaccineDate, screenWidth, Icons.date_range),
            _buildInfoRow('Expiry Date:', vaccineExpiryDate, screenWidth, Icons.warning),
            _buildInfoRow('Veterinarian Notes:', veterinarianNotes, screenWidth, Icons.note),

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
                  child: Text('View Vaccine Certificate', style: TextStyle(color: Config.textColor)),
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
