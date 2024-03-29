import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/models/cart.dart';
import 'package:project/services/voucher_service.dart';
import 'package:provider/provider.dart';

class MyCart extends StatelessWidget {
  const MyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart',style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      ),
      body: Container(
        color: const Color.fromARGB(255, 243, 243, 243),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: _CartList(),
              ),
            ),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Divider(
                  color: Colors.grey,
                )),
            _CartTotal()
          ],
        ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.titleLarge;
    var cart = context.watch<Cart>();

    return ListView.builder(
      itemCount: cart.cartItems.length,
      itemBuilder: (context, index) {
        return StreamBuilder<QuerySnapshot>(
          stream: VoucherService().getVoucherStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              var vouchers = snapshot.data!.docs.toList();
               var voucher = vouchers[index];
              return ListTile(
                leading: Container(
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.rectangle),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${cart.cartItems[index].quantity}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    cart.removeFromCart(cart.cartItems[index].voucherID);
                  },
                ),
                title: Text(
                  voucher['name'],
                  style: itemNameStyle,
                ),
              );
            }
          },
        );
      },
    );
  }
}

class _CartTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<Cart>(
                builder: (context, cart, child) => 
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ordering not supported yet.')));
                                  },
                                   style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),),
                          backgroundColor: Colors.deepOrange,),
                      child:
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Order Now',style: TextStyle(color: Colors.white)),
                              Text('\$${cart.getCartTotal()}',
                              style: const TextStyle(color: Colors.white),),
                            ],
                          ),
                        )
                       ),
                  ),
                )),
          
          ],
        ),
      ),
    );
  }
}
