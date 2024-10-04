import 'package:flutter/material.dart';
import 'package:pet_pal_project/Components/Config.dart';
import 'package:pet_pal_project/Components/ConfirmationAlert.dart';
import 'package:pet_pal_project/Components/GuideAlertMsg.dart';
import 'package:pet_pal_project/Components/SuccessAlert.dart';
import 'package:pet_pal_project/Components/appointmenthistory.dart';
import 'package:pet_pal_project/Components/ongoingcard.dart';
import 'package:pet_pal_project/Config/authServices.dart';
import '../config/global.dart';
import 'package:http/http.dart' as http;

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  List<bool> isSelected = [true, false];
  final List<HistoryCard> history = [];
  final List<OngoingCard> ongoing = [];
  bool isListLoading = true;
  String appointmentID = '';

  @override
  void initState() {
    super.initState();
    _fetchAppointmentData();
  }

  void _fetchAppointmentData() async {
    try {
      // Fetch appointment history
      final List<Map<String, String>> historyAppointments =
      await AuthServices.fetchAppointmentHistory();

      for (Map<String, String> appointment in historyAppointments) {
        history.add(HistoryCard(
          appointmentID: appointment['appointmentID'] ?? 'N/A',
          serviceProviderID: appointment['serviceProviderID'] ?? 'N/A',
          serviceTypeID: appointment['serviceTypeID'] ?? 'N/A',
          petOwnerID: appointment['petOwnerID'] ?? 'N/A',
          petID: appointment['petID'] ?? 'N/A',
          status: appointment['status'] ?? 'Unknown Status',
          date: appointment['date'] ?? 'Unknown Date',
          time: appointment['time'] ?? 'Unknown Time',
        ));
      }

      // Fetch ongoing appointments
      final List<Map<String, String>> ongoingAppointments =
      await AuthServices.fetchOngoingAppointments();

      // Check if ongoingAppointments is empty
      if (ongoingAppointments.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return GuideAlertMsg(
              title: 'No Ongoing Appointments',
              message: 'You have no ongoing appointments at the moment',
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        );
      } else {
        for (Map<String, String> appointment in ongoingAppointments) {
          ongoing.add(OngoingCard(
            appointmentID: appointment['appointmentID'] ?? '',
            serviceProviderID: appointment['serviceProviderID'] ?? 'N/A',
            serviceTypeID: appointment['serviceTypeID'] ?? 'N/A',
            petOwnerID: appointment['petOwnerID'] ?? 'N/A',
            petID: appointment['petID'] ?? 'N/A',
            status: appointment['status'] ?? 'Unknown Status',
            date: appointment['date'] ?? 'Unknown Date',
            time: appointment['time'] ?? 'Unknown Time',
            onRemove: () {
              final id = appointment['appointmentID'];
              print('Attempting to delete appointment with ID: $id'); // Debugging
              if (id != null && id.isNotEmpty) {
                _confirmDelete(id);
              } else {
                print('Error: Invalid appointmentID');
              }
            },
          ));
        }
      }

      setState(() {
        isListLoading = false;
      });
    } catch (e) {
      print('Error fetching appointment data: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Failed to fetch appointments'),
      ));
      setState(() {
        isListLoading = false;
      });
    }
  }

  // Method to show alert when there are no history appointments
  void _showNoHistoryAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GuideAlertMsg(
          title: 'No Appointment History',
          message: 'You have no appointment history at the moment.',
          onPressed: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  // confirm delete
  Future<void> _confirmDelete(String appointmentID) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationAlert(
          message: "Are you sure you want to cancel this appointment?",
          onAction: () => _cancelAppointment(appointmentID),
          actionMessage: 'Delete Appointment',
        );
      },
    );
  }

  Future<void> _cancelAppointment(String appointmentID) async {
    try {
      final token = await AuthServices.getToken();
      final url = Uri.parse('$baseURL/appointments/$appointmentID/cancel');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Uri: $url');

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          ongoing.removeWhere(
                  (appointment) => appointment.appointmentID == appointmentID);
        });

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SuccessAlert(
                message: 'Appointment canceled successfully',
                onAction: () => Navigator.pushReplacementNamed(context, '/main'),
              );
            });
      } else {
        throw Exception('Failed to cancel appointment');
      }
    } catch (e) {
      print('Error canceling appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to cancel appointment')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Config.backgroundColor,
      body: isListLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 7, left: 7, top: 30),
              width: double.infinity,
              height: screenHeight * 0.2,
              decoration: BoxDecoration(
                color: Config.mainColor,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.0,
                    horizontal: screenWidth * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
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
                        Text(
                          "Appointments",
                          style: TextStyle(
                            color: Config.textColor,
                            fontSize: screenWidth * 0.07,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Config.spaceSmall,
                    ToggleButtons(
                      isSelected: isSelected,
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < isSelected.length; i++) {
                            isSelected[i] = i == index;
                          }

                          // Check if 'History' button is selected
                          if (index == 1 && history.isEmpty) {
                            _showNoHistoryAlert(); // Show alert if history is empty
                          }
                        });
                      },
                      color: Colors.white,
                      selectedColor: Config.petSupportingColor,
                      fillColor: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      borderColor: Colors.white,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.09),
                          child: const Text('Ongoing'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.09),
                          child: const Text('History'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                    isSelected[0] ? ongoing.length : history.length,
                    itemBuilder: (context, index) {
                      return isSelected[0]
                          ? ongoing[index]
                          : history[index];
                    },
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
