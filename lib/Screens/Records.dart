import 'package:flutter/material.dart';
import 'package:pet_pal_project/Components/Config.dart';
import 'package:pet_pal_project/Components/GuideAlertMsg.dart';
import 'package:pet_pal_project/Components/LabRecords.dart';
import 'package:pet_pal_project/Components/MedicationRecord.dart';
import 'package:pet_pal_project/Components/VaccinationRecords.dart';
import 'package:pet_pal_project/Config/authServices.dart';



class RecordsPage extends StatefulWidget {
  final String petId;

  const RecordsPage({
    super.key,
    required this.petId,
  });

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  List<bool> isSelected = [true, false, false];
  List<Map<String, String>> LabRecords = [];
  List<Map<String, String>> MedicationRecords = [];
  List<Map<String, String>> VaccinationRecords = [];

  @override
  void initState() {
    super.initState();
    fetchMedicationRecords();
  }

  // Fetch lab service records
  Future<void> fetchLabRecords() async {
    try {
      final records = await AuthServices.fetchLabRecords(widget.petId);
      setState(() {
        LabRecords = records;
      });

      if (records.isEmpty) {
        showDialog(context: context, builder: (context) {
          return GuideAlertMsg(
            title: 'No Records Found',
            message: 'No lab records found for this pet.',
            onPressed: () {
              Navigator.pop(context);
            },
          );
        });
      }
    } catch (e) {
      print('Error fetching lab records: $e');
    }
  }

  // Fetch medication service records
  Future<void> fetchMedicationRecords() async {
    try {
      final records = await AuthServices.fetchMedicationRecords(widget.petId);
      setState(() {
        MedicationRecords = records;

        if (records.isEmpty) {
          showDialog(context: context, builder: (context) {
            return GuideAlertMsg(
              title: 'No Records Found',
              message: 'No medication records found for this pet.',
              onPressed: () {
                Navigator.pop(context);
              },
            );
          });
        }
      });
    } catch (e) {
      print('Error fetching medication records: $e');
    }
  }

  // Fetch vaccination service records
  Future<void> fetchVaccinationRecords() async {
    try {
      final records = await AuthServices.fetchVaccinationRecords(widget.petId);
      setState(() {
        VaccinationRecords = records;

        if (records.isEmpty) {
          showDialog(context: context, builder: (context) {
            return GuideAlertMsg(
              title: 'No Records Found',
              message: 'No vaccination records found for this pet.',
              onPressed: () {
                Navigator.pop(context);
              },
            );
          });
        }
      });
    } catch (e) {
      print('Error fetching vaccination records: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Config.backgroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(right: 7, left: 7, top: 30),
                width: double.infinity,
                height: 280,
                decoration: BoxDecoration(
                  color: Config.mainColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          SizedBox(width: 40),
                          Text(
                            'Medical Records',
                            style: TextStyle(
                              color: Config.textColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Config.spaceSmall,
                      Text(
                        'View your medical records here',
                        style: TextStyle(
                          color: Config.textColor,
                          fontSize: 20,
                        ),
                      ),
                      Config.spaceSmall,
                      ToggleButtons(
                        isSelected: isSelected,
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < isSelected.length; i++) {
                              isSelected[i] = i == index;
                            }
                          });

                          if (index == 0) {
                            fetchMedicationRecords();
                          } else if (index == 1) {
                            fetchVaccinationRecords();
                          } else if (index == 2) {
                            fetchLabRecords();
                          }
                        },
                        color: Config.textColor,
                        selectedColor: Config.textColor,
                        fillColor: Config.backgroundColor,
                        borderRadius: BorderRadius.circular(8.0),
                        borderColor: Colors.white,
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 26.0),
                            child: Text('Medication'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 26.0),
                            child: Text('Vaccination'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 26.0),
                            child: Text('Lab Records'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            backgroundColor: Config.backgroundColor,
                            foregroundColor: Config.textColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text('Download PDF'),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // Display the selected records
              if (isSelected[0]) ...[
                for (var record in MedicationRecords)
                  MedicationCard(
                    medicationID: record['recordID'] ?? '',
                    medicationName: record['medicationName'] ?? '',
                    medicationDosage: record['dosage'] ?? '',
                    medicationFrequency: record['frequency'] ?? '',
                    medicationDuration: '${record['startDate']} - ${record['endDate']}',
                    medicationNotes: record['veterinarianNotes'] ?? '',
                    medicationFileUrl: '', // Add the correct field for file URL
                    onViewFile: () {},
                  )
              ],
              if (isSelected[1]) ...[
                for (var record in VaccinationRecords)
                  VaccinationCard(
                    vaccinationID: record['recordID'] ?? '',
                    vaccineName: record['vaccineName'] ?? '',
                    vaccineDate: record['vaccineDate'] ?? '',
                    vaccineExpiryDate: record['expiryDate'] ?? '',
                    veterinarianNotes: record['veterinarianNotes'] ?? '',
                    vaccineFileUrl: '',
                    onViewFile: () {},
                  )
              ],
              if (isSelected[2]) ...[
                for (var record in LabRecords)
                  LabRecordCard(
                    labID: record['labID'] ?? '',
                    testName: record['testName'] ?? '',
                    results: record['results'] ?? '',
                    testDate: record['testDate'] ?? '',
                    referenceResult: record['referenceResult'] ?? '',
                    veterinarianNotes: record['veterinarianNotes'] ?? '',
                    resultFileUrl: '', // Add the correct field for file URL
                    onViewFile: () {},
                  )
              ],
            ],
          ),
        ),
      ),
    );
  }
}