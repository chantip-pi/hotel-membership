import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> _docIDs = [];
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Add a new user to Firestore
  Future<void> addUserDetails({
    required String uid,
    required String name,
    required String surname,
    required String email,
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
      'email': email,
      'gender': gender,
      'citizenID': citizenID,
      'address': address,
      'birthdate': birthdate,
      'memberID': _generateRandomID(),
      'points': 1000
    });
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


  Future getAllUserIDs() async {
    await _firestore.collection('users').get().then(
      (snapshot) => snapshot.docs.forEach((element) {
        print(element.reference);
        _docIDs.add(element.reference.id);
      }));
  }

   Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        return userSnapshot.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting user details by ID: $e");
      return null;
    }
  }


  Future<Map<String, dynamic>?> getUserByMemberId(String memberID) async {
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
    print("Error getting user details by memberID: $e");
    return null;
  }
}

Future<void> updateUserPoints(String memberID, int newPoints) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('memberID', isEqualTo: memberID)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference userRef = querySnapshot.docs.first.reference;
        await userRef.update({'points': newPoints});

        print('Points updated successfully.');
      } else {
        print('User not found with memberID: $memberID');
      }
    } catch (e) {
      print('Error updating points: $e');
    }
    
  }

}


