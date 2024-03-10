import 'package:cloud_firestore/cloud_firestore.dart';

class VoucherService{
  final CollectionReference vouchers = FirebaseFirestore.instance.collection('vouchers');

  // Create
  Future<void> addVoucher({
    required String name,
    required bool onShop,
    required Timestamp timestamp,
    required int points,
    required Timestamp dueDate,
    required String voucherType,
    required String termsCondition,
    double? discountPercentage,
    double? cashValue,
    String? giftItem,
  }) {
    return vouchers.add({
      'name': name,
      'onShop': onShop,
      'timestamp': timestamp,
      'points': points,
      'dueDate': dueDate,
      'voucherType': voucherType,
      'termsCondition': termsCondition,
      'discountPercentage': discountPercentage,
      'cashValue': cashValue,
      'giftItem': giftItem,
    });
  }

  // Read
  Stream<QuerySnapshot> getVoucherStream() {
    final voucherStream = vouchers.orderBy('name', descending: false).snapshots();
    return voucherStream;
  }

  // Update
  Future<void> deleteVoucher(String docID) {
    return vouchers.doc(docID).update({
      'onShop': false,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getVoucherStreamByCategory(String category) {
    final voucherStream = vouchers
        .where('voucherType', isEqualTo: category)
        .orderBy('points', descending: false)
        .snapshots();
    return voucherStream;
  }
  
}
