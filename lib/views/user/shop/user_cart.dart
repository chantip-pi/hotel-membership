import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cart extends ChangeNotifier {
  List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  void addToCart(Product product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void purchaseItems(String userId) async {
    final CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');
    for (Product product in _cartItems) {
      await orders.add({
        'userId': userId,
        'name': product.name,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'timestamp': DateTime.now(),
      });
    }
    _cartItems.clear();
    notifyListeners();
  }
}

class Product {
  final String name;
  final String price;
  final String imageUrl;

  Product({required this.name, required this.price, required this.imageUrl});
}

class UserCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final userId = ''; // You should replace this with the actual user ID

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Details'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.purchaseItems(userId);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: cart.cartItems.length,
        itemBuilder: (context, index) {
          final product = cart.cartItems[index];
          return ListTile(
            leading: Image.network(product.imageUrl),
            title: Text(product.name),
            subtitle: Text(product.price),
          );
        },
      ),
    );
  }
}
