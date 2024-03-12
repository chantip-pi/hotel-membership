import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FormatUtils {
  static String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length != 10) {
      return 'Invalid phone number';
    }

    return '${phoneNumber.substring(0, 3)} ${phoneNumber.substring(3, 6)} ${phoneNumber.substring(6)}';
  }


  static String addSpaceToNumberString(String numberString) {
    String formattedNumber = '';

    for (int i = 0; i < numberString.length; i++) {
      if (i > 0 && (numberString.length - i) % 4 == 0) {
        formattedNumber += ' ';
      }
      formattedNumber += numberString[i];
    }

    return formattedNumber;
  }

    static String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('dd MMM yyyy').format(date);
  }

}