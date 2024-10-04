import 'package:flutter/material.dart';

class OngoingCard extends StatelessWidget {
  final String appointmentID;
  final String serviceProviderID;
  final String serviceTypeID;
  final String petOwnerID;
  final String petID;
  final String status;
  final String date;
  final String time;
  final VoidCallback onRemove;

  const OngoingCard({
    Key? key,
    required this.appointmentID,
    required this.serviceProviderID,
    required this.serviceTypeID,
    required this.petOwnerID,
    required this.petID,
    required this.status,
    required this.date,
    required this.time,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
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
            _buildInfoRow('Appointment No:', appointmentID, screenWidth, Icons.assignment),
            _buildInfoRow('Service Provider ID:', serviceProviderID, screenWidth, Icons.person),
            _buildInfoRow('Service Type ID:', serviceTypeID, screenWidth, Icons.work),
            _buildInfoRow('Pet Owner ID:', petOwnerID, screenWidth, Icons.person),
            _buildInfoRow('Pet ID:', petID, screenWidth, Icons.pets),
            _buildInfoRow('Status:', status, screenWidth, Icons.check_circle),
            _buildInfoRow('Date:', date, screenWidth, Icons.date_range),
            _buildInfoRow('Time:', time, screenWidth, Icons.access_time),


            SizedBox(height: screenHeight * 0.02),


            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    textStyle: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                  onPressed: onRemove,
                  child: const Text('Cancel', style: TextStyle(color: Colors.white),),
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
          Icon(icon, size: screenWidth * 0.05, color: Colors.grey.shade600),
          SizedBox(width: screenWidth * 0.02),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.04,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.grey.shade600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
