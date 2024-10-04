import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  Future<File> _getLocalFile(String userId) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/profile_data_$userId.json';
    return File(filePath);
  }

  Future<Map<String, dynamic>?> readProfile(String userId) async {
    try {
      final file = await _getLocalFile(userId);
      if (await file.exists()) {
        String content = await file.readAsString();
        return jsonDecode(content);
      }
    } catch (e) {
      print("Error reading profile: $e");
    }
    return null;
  }

  Future<void> saveProfile(String userId,
      Map<String, dynamic> profileData) async {
    final file = await _getLocalFile(userId);
    try {
      if (profileData['profile_pic'] == null) {
        profileData['profile_pic'] = ''; // Initialize with empty string
      }
      String jsonString = jsonEncode(profileData);
      await file.writeAsString(jsonString);
    } catch (e) {
      print("Error writing profile: $e");
    }
  }

  Future<void> deleteProfile(String userId) async {
    final file = await _getLocalFile(userId);
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print("Error deleting profile: $e");
    }
  }


// pet
  Future<File> getLocalPetFile(String userId, int petId) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/pet_data_${userId}_$petId.json';
    return File(filePath);
  }

  // Update savePet to use the new public method
  Future<void> savePet(String userId, int petId, Map<String, dynamic> petData) async {
    petData['petId'] = petId.toString();
    final file = await getLocalPetFile(userId, petId); // Adjusted here
    try {
      if (petData['pet_pic'] == null) {
        petData['pet_pic'] = '';
      }
      String jsonString = jsonEncode(petData);
      await file.writeAsString(jsonString);
    } catch (e) {
      print("Error writing pet data: $e");
    }
  }

  // Update readPet to use the new public method
  Future<Map<String, dynamic>?> readPet(String userId, int petId) async {
    try {
      final file = await getLocalPetFile(userId, petId);
      if (await file.exists()) {
        String content = await file.readAsString();
        return jsonDecode(content);
      }
    } catch (e) {
      print("Error reading pet data: $e");
    }
    return null;
  }

  // Similarly update deletePet if needed
  Future<void> deletePet(String userId, int petId) async {
    final file = await getLocalPetFile(userId, petId);
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print("Error deleting pet data: $e");
    }
  }


  Future<List<Map<String, dynamic>>> loadAllPetsForUser(String userId) async {
    final directory = await getApplicationDocumentsDirectory();
    List<Map<String, dynamic>> petDataList = [];

    final List<FileSystemEntity> files = directory.listSync();
    for (var file in files) {
      if (file.path.contains('pet_data_${userId}_')) {
        String content = await File(file.path).readAsString();
        Map<String, dynamic> petData = jsonDecode(content);
        petDataList.add(petData);
      }
    }
    return petDataList;
  }
}
