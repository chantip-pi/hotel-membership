import 'package:flutter/material.dart';
import 'package:project/models/item.dart';
import 'package:project/services/user_purchase.dart';
import 'package:project/services/voucher_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cart extends ChangeNotifier {
  List<Item> _cartItems = [];

  List<Item> get cartItems => _cartItems;

  void addToCart(String voucherID, int quantity) {
    var isExist = _cartItems.where((element) => element.voucherID == voucherID);
    if (isExist.isEmpty) {
      _cartItems.add(Item(
          voucherID: voucherID,
          quantity: quantity,
          timestamp: Timestamp.now(),
          userID: FirebaseAuth.instance.currentUser!.uid));
    } else {
      isExist.first.quantity += quantity;
    }
    notifyListeners();
  }

  void removeFromCart(String voucherID) {
    _cartItems.removeWhere((item) => item.voucherID == voucherID);
    notifyListeners();
  }

  void purchaseItems(String userID) async {
    for (Item item in _cartItems) {
      for (int i = 0; i < item.quantity; i++) {
        await UserPurchaseService().addPurchase(
            userID: FirebaseAuth.instance.currentUser!.uid,
            voucherID: item.voucherID);
      }
    }
    _cartItems.clear();
    notifyListeners();
  }

    void incrementQty(String voucherID) {
    Item item =
        _cartItems.where((element) => element.voucherID == voucherID).first;
    item.quantity++;
    notifyListeners();
  }

  void decrimentQty(String voucherID) {
    Item item =
        _cartItems.where((element) => element.voucherID == voucherID).first;

    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _cartItems.remove(item);
    }
    notifyListeners();
  }


  Future<double> getCartTotal() async {
    double total = 0;
    for (var item in _cartItems) {
      var voucherData = await VoucherService().getVoucherByID(item.voucherID).first;
      total += (voucherData['points'] as double) * item.quantity;
    }
    return total;
  }
}
