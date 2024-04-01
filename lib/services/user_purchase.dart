import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/item.dart';
import 'package:project/services/voucher_service.dart';

class UserPurchaseService {
  final CollectionReference purchases =
      FirebaseFirestore.instance.collection('userPurchase');
  final CollectionReference vouchers =
      FirebaseFirestore.instance.collection('vouchers');

  // add single purchase
  Future<void> addPurchase(
      {required String userID,
      required String voucherID}) {
    return purchases.add({
      'userID': userID,
      'voucherID': voucherID,
      'timestamp': Timestamp.now(),
      'isRedeem': false
    });
  }

  //add all purchase in cart
  Future<void> purchaseItems(String userID, List<Item> cartItems) async {
    for (var cartItem in cartItems) {
      for (var i = 0; i < cartItem.quantity; i++) {
        await addPurchase(
          userID: userID,
          voucherID: cartItem.voucherID,
        );
      }
    }
  }

  // Read
  Stream<QuerySnapshot> getPurchaseStream() {
    final voucherStream =
        purchases.orderBy('timestamp', descending: true).snapshots();
    return voucherStream;
  }

  // Update Voucher to be redeem
  Future<void> redeemVoucher(String docID) {
    return purchases.doc(docID).update({
      'isRedeem': true,
      'timestamp': Timestamp.now(),
    });
  }

  Future<List<String>> getAllVoucherIDsForUser(String userID) async {
    try {
      // Querying userPurchases collection to find all purchases made by the user
      QuerySnapshot userPurchaseSnapshot =
          await purchases.where('userID', isEqualTo: userID).get();
      // Extracting voucher IDs from user purchases
      List<String> voucherIDs = [];
      for (var doc in userPurchaseSnapshot.docs) {
        voucherIDs.add(doc.get('voucherID') as String);
      }

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
      for (var doc in snapshot.docs) {
        print(doc.data());
      }
    });

    return voucherStream;
  }

  Future<Stream<QuerySnapshot>> getVoucherStreamForUser(String userID) async {
    try {
      // Querying userPurchases collection to find all purchases made by the user
      QuerySnapshot userPurchaseSnapshot =
          await purchases.where('userID', isEqualTo: userID).get();

      // Extracting voucher IDs from user purchases
      List<String> voucherIDs = [];
      for (var doc in userPurchaseSnapshot.docs) {
        voucherIDs.add(doc.get('voucherID') as String);
        print(voucherIDs);
      }

      // Now that you have the voucher IDs, you can call getVoucherStreamByIDs
      return getVoucherStreamByIDs(voucherIDs);
    } catch (e) {
      // Handle error
      print('Error fetching user purchase data: $e');
      return Stream.empty(); // Return an empty stream in case of error
    }
  }

  Future<List<Map<String, dynamic>>> getUserPurchasesWithVoucherInfo(
      String userID) async {
    try {
      // Query purchases collection to find the documents with the given userID
      QuerySnapshot purchaseSnapshot =
          await purchases.where('userID', isEqualTo: userID).get();
      if (purchaseSnapshot.docs.isEmpty) {
        return []; // No purchases found for the given userID
      }
      // List to store user purchases with voucher info
      List<Map<String, dynamic>> userPurchasesWithVoucherInfo = [];

      // Loop through each user purchase document
      for (DocumentSnapshot purchaseDoc in purchaseSnapshot.docs) {
        String voucherID = purchaseDoc['voucherID'] as String;
        bool isRedeem = purchaseDoc['isRedeem'] as bool;

        String purchaseID = purchaseDoc.id;
        // Query vouchers collection to get the voucher info
        DocumentSnapshot voucherSnapshot = await vouchers.doc(voucherID).get();
        if (!voucherSnapshot.exists) {
          continue; // Skip if no voucher found with the given voucherID
        }

        // Extract voucher info
        Map<String, dynamic> voucherInfo =
            voucherSnapshot.data() as Map<String, dynamic>;

        // Add user purchase with voucher info to the list only if isRedeem is false
        if (!isRedeem) {
          userPurchasesWithVoucherInfo.add({
            'purchaseID': purchaseID,
            'userID': userID,
            'voucherID': voucherID,
            'voucherInfo': voucherInfo,
            'isRedeem': isRedeem,
          });
        }
      }
      // Return the list of user purchases with voucher info
      return userPurchasesWithVoucherInfo;
    } catch (e) {
      print('Error retrieving user purchases with voucher info: $e');
      return [];
    }
  }

  Future<Map<String, List<Map<String, dynamic>>>> getVouchersByCategory(
      String category, String userID) async {
    try {
      // Retrieve user purchases with voucher info for the given category
      List<Map<String, dynamic>> userPurchasesWithVoucherInfo =
          await getUserPurchasesWithVoucherInfo(userID);

      // Categorize vouchers by type
      Map<String, List<Map<String, dynamic>>> categorizedVouchers = {};
      for (var purchaseInfo in userPurchasesWithVoucherInfo) {
        String voucherType =
            purchaseInfo['voucherInfo']['voucherType'] as String;
        categorizedVouchers.putIfAbsent(voucherType, () => []);
        if (voucherType == category) {
          categorizedVouchers[voucherType]!.add(purchaseInfo['voucherInfo']);
        }
      }

      return categorizedVouchers;
    } catch (e) {

      print('Error retrieving vouchers by category: $e');
      return {};
    }
  }

  
}
