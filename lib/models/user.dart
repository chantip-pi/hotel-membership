import 'dart:math';

class User {
  String name;
  String surname;
  String email;
  String password;
  String phone;
  String citizenID;
  String address;
  DateTime birthdate;
  String gender;
  String memberID;

  User({
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
    required this.phone,
    required this.citizenID,
    required this.address,
    required this.birthdate,
    required this.gender,
    String? memberID, // Allow memberID to be nullable
  }) : memberID = memberID ?? _generateRandomID(12); // If memberID is null, generate a default one


  static String _generateRandomID(int length) {
    final Random random = Random();
    const String chars = '0123456789';
    String result = '';

    for (int i = 0; i < length; i++) {
      result += chars[random.nextInt(chars.length)];
    }

    return result;
  }
}
