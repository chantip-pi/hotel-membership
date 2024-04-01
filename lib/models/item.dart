import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String userID;
  final String voucherID;
  int quantity;
  Timestamp timestamp;

  Item({
    required this.userID,
    required this.voucherID,
    required this.quantity,
     required this.timestamp,
  });
}