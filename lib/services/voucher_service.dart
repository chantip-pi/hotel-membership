import 'package:cloud_firestore/cloud_firestore.dart';

class VoucherService {
  final CollectionReference vouchers =
      FirebaseFirestore.instance.collection('vouchers');

  // Create
  Future<void> addVoucher(
      {required String name,
      required bool onShop,
      required Timestamp timestamp,
      required int points,
      required Timestamp dueDate,
      required String voucherType,
      required String termsCondition,
      double? discountPercentage,
      double? cashValue,
      String? giftItem,
      String? imageUrl}) {
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
      'imageUrl': imageUrl
    });
  }

    Future<void> updateVoucher(
    String docID, {
    String? name,
    bool? onShop,
    Timestamp? timestamp,
    int? points,
    Timestamp? dueDate,
    String? voucherType,
    String? termsCondition,
    double? discountPercentage,
    double? cashValue,
    String? giftItem,
    String? imageUrl,
  }) {
    Map<String, dynamic> dataToUpdate = {};

    if (name != null) dataToUpdate['name'] = name;
    if (onShop != null) dataToUpdate['onShop'] = onShop;
    if (timestamp != null) dataToUpdate['timestamp'] = timestamp;
    if (points != null) dataToUpdate['points'] = points;
    if (dueDate != null) dataToUpdate['dueDate'] = dueDate;
    if (voucherType != null) dataToUpdate['voucherType'] = voucherType;
    if (termsCondition != null) dataToUpdate['termsCondition'] = termsCondition;
    if (discountPercentage != null) dataToUpdate['discountPercentage'] = discountPercentage;
    if (cashValue != null) dataToUpdate['cashValue'] = cashValue;
    if (giftItem != null) dataToUpdate['giftItem'] = giftItem;
    if (imageUrl != null) dataToUpdate['imageUrl'] = imageUrl;

    return vouchers.doc(docID).update(dataToUpdate);
  }

  Stream<QuerySnapshot> getVoucherStream() {
    final voucherStream =
        vouchers.orderBy('timestamp', descending: true).snapshots();
    return voucherStream;
  }


  Future<void> deleteVoucher(String docID) {
    return vouchers.doc(docID).update({
      'onShop': false,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getVoucherStreamByCategory(String category) {
    final voucherStream = vouchers
        .where('voucherType', isEqualTo: category)
        .where((doc) => doc['onShop'] == true)
        .orderBy('timestamp', descending: false)
        .snapshots();
    return voucherStream;
  }

  Stream<QuerySnapshot> getVoucherStreamByIDs(List<String> voucherIDs) {
    final voucherStream = vouchers
        .where(FieldPath.documentId, whereIn: voucherIDs)
        .snapshots();
    return voucherStream;
  }

  Stream<DocumentSnapshot> getVoucherByID(String voucherID) {
    final voucher = vouchers.doc(voucherID).snapshots();
    return voucher;
  }
}
