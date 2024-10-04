import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pet_pal_project/Config/LocalStorageService.dart';
import 'global.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthServices {
  static final FlutterSecureStorage storage = const FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getToken() async {
    final token = await storage.read(key: 'auth_token');
    print('Retrieved token: $token'); // Debugging
    return token;
  }

  static Future<void> deleteToken() async {
    await storage.delete(key: 'auth_token');
  }


  // Save user ID as String
  static Future<void> saveID(int userId) async {
    await storage.write(key: 'user_id', value: userId.toString());
  }

  // Get user ID as String
  static Future<String?> getID() async {
    String? userId = await storage.read(key: 'user_id');
    print('Retrieved user_id: $userId');
    return userId;
  }

  // Get user ID as int
  static Future<int?> getIDAsInt() async {
    String? userIdString = await storage.read(key: 'user_id');
    print('Retrieved user_id: $userIdString');
    return userIdString != null ? int.tryParse(userIdString) : null;
  }

  // Delete user ID
  static Future<void> deleteID() async {
    await storage.delete(key: 'user_id');
  }


  // pet ID save
  static Future<void> savePetID(int petId) async {
    await storage.write(key: 'pet_id', value: petId.toString());
  }

  // pet ID get
  static Future<String?> getPetID() async {
    String? petId = await storage.read(key: 'pet_id');
    print('Retrieved pet_id: $petId');
    return petId;
  }

  // pet ID delete
  static Future<void> deletePetID() async {
    await storage.delete(key: 'pet_id');
  }


  // register function
  static Future<http.Response> register(
      String name, String email, String password) async {
    Map data = {
      "name": name,
      "email": email,
      "password": password,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/auth/register');
    http.Response response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    print('Request Body: $body'); // Debugging
    print('Response Body: ${response.body}'); // Debugging
    print('Response Status Code: ${response.statusCode}'); // Debugging

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);

      // Handle token and user_id
      String token = responseBody['token'];
      int userId = responseBody['user_id'];

      // Save token and user ID after successful registration
      await AuthServices.saveToken(token);
      await AuthServices.saveID(userId);

      // Create user profile file locally
      Map<String, dynamic> profileData = {
        "name": name,
        "email": email,
        "address": '',
        "phoneNo": '',
        "profile_pic": ''
      };

      // Save profile using LocalStorageService
      LocalStorageService storageService = LocalStorageService();
      await storageService.saveProfile(userId.toString(), profileData);
      print('Profile saved locally for user: $userId');
    } else {
      print('Failed to register user. Status code: ${response.statusCode}');
    }
    return response;
  }


  // login function
  static Future<http.Response> login(String email, String password) async {
    Map data = {"email": email, "password": password};
    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/auth/login');
    print('Login request to $url with body $body'); // Debugging

    http.Response response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print('Login response status: ${response.statusCode}'); // Debugging
    print('Login response body: ${response.body}'); // Debugging

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      print('Token: ${responseBody['token']}'); // Debugging
      await saveToken(responseBody['token']);
      print('ID: ${responseBody['user_id']}'); // Debugging
      await saveID(responseBody['user_id']);
    }
    return response;
  }

// Pet registration with multipart support
  static Future<Map<String, dynamic>> petregister(
      Map<String, String> saveData,
      File? pet_image) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token is null');
    }

    final uri = Uri.parse('$baseURL/pets/register');

    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token';

    // Add form fields to the request
    saveData.forEach((key, value) {
      request.fields[key] = value;
    });

    // Add pet image if it's provided
    if (pet_image != null) {
      request.files.add(
        await http.MultipartFile.fromPath('pet_image', pet_image.path),
      );
    }

    // Send the request and handle the response
    final response = await request.send();
    final responseBody = await http.Response.fromStream(response);

    print('Response: ${responseBody.body}'); // Debugging

    if (response.statusCode == 200) {
      // Parse the response body
      final Map<String, dynamic> responseData = json.decode(responseBody.body);

      // Assuming the response contains a 'status' and 'pet_id'
      if (responseData['status'] == 'success') {
        return {
          'status': responseData['status'],
          'pet_id': responseData['pet_id'], // Extract pet ID from the response
        };
      } else {
        throw Exception('Failed to create pet: ${responseData['message']}');
      }
    } else {
      throw Exception('Failed to create pet: ${responseBody.body}');
    }
  }


  // pet list
  static Future<http.Response> petlist() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token is null');
    }

    var url = Uri.parse(baseURL + '/pets/list');
    http.Response response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Response Body: ${response.body}');
    print('Response Status Code: ${response.statusCode}');

    return response;
  }


  // pet delete
  static Future<http.Response> petdelete(int petID) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token is null');
    }

    var url = Uri.parse(baseURL + '/pets/delete/$petID');
    http.Response response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Response Body: ${response.body}');
    print('Response Status Code: ${response.statusCode}');

    return response;
  }



  //change password
  static Future<http.Response> changePassword(
      String currentPassword,
      String newPassword,
      String confirmPassword,
      ) async {
    try {
      final token = await getToken();
      Map data = {
        "old_password": currentPassword,
        "new_password": newPassword,
        "confirm_password": confirmPassword,
      };

      var body = json.encode(data);
      var url = Uri.parse(baseURL + '/changepassword');

      http.Response response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      print('Request Body: $body'); // Debugging
      print('Response Body: ${response.body}'); // Debugging

      return response; // Return the response in normal cases
    } catch (e) {
      print('Error in changePassword: $e');
      // Return a default Response with an error status code (e.g., 500) in case of an error
      return http.Response('Error occurred', 500);
    }
  }



  // delete user
  static Future<http.Response> deleteUser() async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse(baseURL + '/deleteuser'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('Delete response status: ${response.statusCode}'); // Debugging
    print('Delete response body: ${response.body}'); // Debugging
    return response;
  }





// get profile details
  static Future<Map<String, dynamic>> ProfileDetails() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(baseURL + '/profile/details'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Response: ${response.body}'); // Debugging
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load profile details');
    }
  }


  // profile update
  static Future<String> updateProfile(
      Map<String, String> updatedData, File? image) async {
    final token = await getToken();
    final uri = Uri.parse('$baseURL/profile/save');

    var request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $token';

    // Add text fields to the request
    updatedData.forEach((key, value) {
      request.fields[key] = value;
    });

    // Add the image file if it's available
    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath('profile_pic', image.path),
      );
    }

    final response = await request.send();
    final responseBody = await http.Response.fromStream(response);

    print('Response: ${responseBody.body}'); // Debugging

    if (response.statusCode == 200) {
      return 'success';
    } else {
      throw Exception('Failed to update profile');
    }
  }



  static Future<List<Map<String, String>>> fetchAppointmentHistory() async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse(baseURL + '/appointments/past'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Log the response body
        print('Response Body: ${response.body}');

        // Decode the JSON response
        List<dynamic> jsonResponse = json.decode(response.body);

        // Log the structure of the response
        print('Decoded JSON: $jsonResponse');

        // Map the appointments to the expected structure
        return jsonResponse.map((appointment) {
          return {
            'appointmentID': appointment['id'].toString(),
            'date': appointment['date'].toString(),
            'time': appointment['time'].toString(),
            'status': appointment['status'].toString(),
            'serviceProviderID': appointment['service_provider_id'].toString(),
            'serviceTypeID': appointment['service_type_id'].toString(),
            'petOwnerID': appointment['pet_owner_id'].toString(),
            'petID': appointment['pet_id'].toString(),
          };
        }).toList();
      } else {
        print('Error: Server responded with status code ${response.statusCode}');
        throw Exception('Failed to load appointment history');
      }
    } catch (e) {
      print('Error in fetchAppointmentHistory: $e');
      throw Exception('An error occurred while fetching appointment history');
    }
  }


  static Future<List<Map<String, String>>> fetchOngoingAppointments() async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse(baseURL + '/appointments/upcoming'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Log the response body
        print('Response Body: ${response.body}');

        // Decode the JSON response
        List<dynamic> jsonResponse = json.decode(response.body);

        // Log the structure of the response
        print('Decoded JSON: $jsonResponse');

        // Map the appointments to the expected structure
        return jsonResponse.map((appointment) {
          return {
            'appointmentID': appointment['id'].toString(),
            'date': appointment['date'].toString(),
            'time': appointment['time'].toString(),
            'status': appointment['status'].toString(),
            'serviceProviderID': appointment['service_provider_id'].toString(),
            'serviceTypeID': appointment['service_type_id'].toString(),
            'petOwnerID': appointment['pet_owner_id'].toString(),
            'petID': appointment['pet_id'].toString(),
          };
        }).toList();
      } else {
        print('Error: Server responded with status code ${response.statusCode}');
        throw Exception('Failed to load ongoing appointments');
      }
    } catch (e) {
      print('Error in fetchOngoingAppointments: $e');
      throw Exception('An error occurred while fetching ongoing appointments');
    }
  }


  // Fetch lab records
  static Future<List<Map<String, String>>> fetchLabRecords(String petId) async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse(baseURL + '/lab-records/$petId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Log the response body
        print('Response Body: ${response.body}');

        // Decode the JSON response
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Check if data exists and is a list
        if (jsonResponse['data'] is List && jsonResponse['data'].isNotEmpty) {
          List<dynamic> records = jsonResponse['data'];
          return records.map((record) {
            return {
              'labID': record['id'].toString(),
              'testName': record['test_name'].toString(),
              'results': record['results'].toString(),
              'testDate': record['test_date'].toString(),
              'referenceResult': record['reference_result'].toString(),
              'veterinarianNotes': record['veterinarian_notes'].toString(),
              'resultFileUrl': record['result_file_url'].toString(),
            };
          }).toList();
        } else {
          // If no records are found, return an empty list
          return [];
        }
      } else {
        print('Error: Server responded with status code ${response.statusCode}');
        throw Exception('Failed to load lab records');
      }
    } catch (e) {
      print('Error in fetchLabRecords: $e');
      throw Exception('An error occurred while fetching lab records');
    }
  }


  // Fetch medication records
  static Future<List<Map<String, String>>> fetchMedicationRecords(String petId) async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse(baseURL + '/medications/$petId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Log the response body
        print('Response Body: ${response.body}');

        // Decode the JSON response
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Check if data exists and is a list
        if (jsonResponse['data'] is List && jsonResponse['data'].isNotEmpty) {
          List<dynamic> records = jsonResponse['data'];
          return records.map((record) {
            return {
              'medicationID': record['id'].toString(),
              'medicationName': record['medication_name'].toString(),
              'dosage': record['dosage'].toString(),
              'frequency': record['frequency'].toString(),
              'startDate': record['start_date'].toString(),
              'endDate': record['end_date'].toString(),
              'veterinarianNotes': record['veterinarian_notes'].toString(),
              'prescriptionFileUrl': record['prescription_file_url'].toString(),
            };
          }).toList();
        } else {
          // If no records are found, return an empty list
          return [];
        }
      } else {
        print('Error: Server responded with status code ${response.statusCode}');
        throw Exception('Failed to load medication records');
      }
    } catch (e) {
      print('Error in fetchMedicationRecords: $e');
      throw Exception('An error occurred while fetching medication records');
    }
  }

  // Fetch vaccination records
  static Future<List<Map<String, String>>> fetchVaccinationRecords(String petId) async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse(baseURL + '/vaccinations/$petId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Log the response body
        print('Response Body: ${response.body}');

        // Decode the JSON response and extract the 'data' field
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];

        // Log the structure of the response
        print('Decoded JSON Data: $data');

        // Map the vaccination records to the expected structure
        return data.map((record) {
          return {
            'vaccinationID': record['id'].toString(),
            'vaccineName': record['vaccine_name'].toString(),
            'vaccineDate': record['vaccine_date'].toString(),
            'nextDueDate': record['next_due_date'].toString(),
            'veterinarianNotes': record['veterinarian_notes'].toString(),
            'vaccineFileUrl': record['vaccine_file_url'].toString(),

          };
        }).toList();
      } else {
        print('Error: Server responded with status code ${response.statusCode}');
        throw Exception('Failed to load vaccination records');
      }
    } catch (e) {
      print('Error in fetchVaccinationRecords: $e');
      throw Exception('An error occurred while fetching vaccination records');
    }
  }

}