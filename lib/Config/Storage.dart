import 'package:pet_pal_project/Config/LocalStorageService.dart';

class ProfileService {
  final LocalStorageService _localStorage = LocalStorageService();

  // Save profile data
  Future<void> saveProfileData(String userId, Map<String, dynamic> profileData) async {
    await _localStorage.saveProfile(userId, profileData);
  }

  // Load profile data
  Future<Map<String, dynamic>?> loadProfileData(String userId) async {
    return await _localStorage.readProfile(userId);
  }

  // Delete profile data
  Future<void> deleteProfileData(String userId) async {
    await _localStorage.deleteProfile(userId);
  }

// pet
// Save pet data with userId and petId
  Future<void> savePetData(String userId, int petId, Map<String, dynamic> petData) async {
    await _localStorage.savePet(userId, petId, petData);
  }

  // Load pet data for a specific user and pet
  Future<Map<String, dynamic>?> loadPetData(String userId, int petId) async {
    return await _localStorage.readPet(userId, petId);
  }

  // Load all pets for a specific user
  Future<List<Map<String, dynamic>>> loadAllPetsForUser(String userId) async {
    return await _localStorage.loadAllPetsForUser(userId);
  }

  // Delete pet data for a specific user and pet
  Future<void> deletePetData(String userId, int petId) async {
    await _localStorage.deletePet(userId, petId);
  }
}
