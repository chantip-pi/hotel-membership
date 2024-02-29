import 'dart:math';

class User {
  String uid;
  String memberID;

  User({
    required this.uid,
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
