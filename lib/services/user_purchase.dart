import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/services/voucher_service.dart';

class UserPurchaseService{
  final CollectionReference purchases = FirebaseFirestore.instance.collection('userPurchase');
  final CollectionReference vouchers = FirebaseFirestore.instance.collection('vouchers');

  // Create
  Future<void> addPurchase({
    required String userID,
    required String voucherID,
    required bool isRedeem
  }) {
    return purchases.add({
      'userID': userID,
      'voucherID': voucherID,
      'timestamp': Timestamp.now(),
      'isRedeem' : false
    });
  }

  // Read
  Stream<QuerySnapshot> getPurchaseStream() {
    final voucherStream = purchases.orderBy('timestamp', descending: true).snapshots();
    return voucherStream;
  }

  // Update
  Future<void> redeemVoucher(String docID) {
    return purchases.doc(docID).update({
      'redeem': true,
      'timestamp': Timestamp.now(),
    });
  }

 Future<List<String>> getAllVoucherIDsForUser(String userID) async {
    try {
      // Querying userPurchases collection to find all purchases made by the user
      QuerySnapshot userPurchaseSnapshot = await purchases
          .where('userID', isEqualTo: userID)
          .get();
      // Extracting voucher IDs from user purchases
      List<String> voucherIDs = [];
      userPurchaseSnapshot.docs.forEach((doc) {
        voucherIDs.add(doc.get('voucherID') as String);
      });

      return voucherIDs;
    } catch (e) {
      // Handle error
      print('Error fetching user purchase data: $e');
      return [];
    }
  }

Stream<QuerySnapshot> getVoucherStreamByIDs(List<String> voucherIDs) {
  final voucherStream = FirebaseFirestore.instance
      .collection('vouchers')
      .where(FieldPath.documentId, whereIn: voucherIDs)
      .snapshots();

  voucherStream.listen((snapshot) {
    snapshot.docs.forEach((doc) {
      print(doc.data());
    });
  });

  return voucherStream;
}


Future<Stream<QuerySnapshot>> getVoucherStreamForUser(String userID) async {
  try {
    // Querying userPurchases collection to find all purchases made by the user
    QuerySnapshot userPurchaseSnapshot = await purchases
        .where('userID', isEqualTo: userID)
        .get();

    // Extracting voucher IDs from user purchases
    List<String> voucherIDs = [];
    userPurchaseSnapshot.docs.forEach((doc) {
      voucherIDs.add(doc.get('voucherID') as String);
      print(voucherIDs);
    });

    // Now that you have the voucher IDs, you can call getVoucherStreamByIDs
    return getVoucherStreamByIDs(voucherIDs);
  } catch (e) {
    // Handle error
    print('Error fetching user purchase data: $e');
    return Stream.empty(); // Return an empty stream in case of error
  }
}

  
 
}






