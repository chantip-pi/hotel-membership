import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new user to Firestore
  Future<void> addUserDetails({
    required String uid,
    required String name,
    required String surname,
    required String phone,
    required String gender,
    required String citizenID,
    required String address,
    required DateTime birthdate,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'surname': surname,
      'phone': phone,
      'gender': gender,
      'citizenID': citizenID,
      'address': address,
      'birthdate': birthdate,
      'memberID': _generateRandomID(),
      'points': 1000
    });
  }

  // Get user details by UID
  Future<Map<String, dynamic>?> getUserByUid(String uid) async {
    try {
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(uid).get();

      if (userSnapshot.exists) {
        return userSnapshot.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      // Handle any potential errors
      print("Error getting user details: $e");
      return null;
    }
  }

  // Get user details by memberID
  Future<Map<String, dynamic>?> getUserByMemberID(String memberID) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('memberID', isEqualTo: memberID)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      // Handle any potential errors
      print("Error getting user details by memberID: $e");
      return null;
    }
  }
  // generatememberID
    String _generateRandomID() {
    final Random random = Random();
    const String chars = '0123456789';
    String result = '';
    for (int i = 0; i < 16; i++) {
      result += chars[random.nextInt(chars.length)];
    }
    return result;
  }
}


