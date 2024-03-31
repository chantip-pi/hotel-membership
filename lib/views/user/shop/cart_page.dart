import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/models/cart.dart';
import 'package:project/services/user_purchase.dart';
import 'package:project/services/user_service.dart';
import 'package:project/services/voucher_service.dart';
import 'package:project/utils/theme.dart';
import 'package:provider/provider.dart';

class MyCart extends StatelessWidget {
  const MyCart({super.key});

  @override
  Widget build(BuildContext context) {
    Widget _buildCartList() {
      var cart = context.watch<Cart>();

      return ListView.builder(
        itemCount: cart.cartItems.length,
        itemBuilder: (context, index) {
          return StreamBuilder<DocumentSnapshot>(
            stream: VoucherService()
                .getVoucherByID(cart.cartItems[index].voucherID),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                var voucher = snapshot.data!.data() as Map<String, dynamic>;
                String name = voucher['name'];
                String displayName;
                if (name.length > 30) {
                  displayName = '${name.substring(0, 30)}...';
                } else {
                  displayName = name;
                }
                return Card(
                  elevation: 6,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0),
                        ),
                        child: Image.network(
                          voucher['imageUrl'],
                          height: 150,
                          width: 150,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      cart.cartItems[index].quantity == 1
                                          ? showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:
                                                      const Text('Remove Item'),
                                                  content: const Text(
                                                      'Are you sure you want to remove this item from your cart?'),
                                                  backgroundColor: Colors.white,
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        cart.removeFromCart(cart
                                                            .cartItems[index]
                                                            .voucherID);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                        'Remove',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            )
                                          : cart.decreaseQuantity(
                                              cart.cartItems[index].voucherID);
                                    },
                                    icon: const Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black),
                                      shape: MaterialStateProperty.all(
                                          CircleBorder()),
                                      padding: MaterialStateProperty.all(
                                        EdgeInsets.all(5),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                    child: Center(
                                      child: Text(
                                        '${cart.cartItems[index].quantity}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      cart.increaseQuantity(
                                          cart.cartItems[index].voucherID);
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black),
                                      shape: MaterialStateProperty.all(
                                          CircleBorder()),
                                      padding: MaterialStateProperty.all(
                                        EdgeInsets.all(5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryColor,
        centerTitle: true,
      ),
      body: Container(
        color: AppTheme.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: _buildCartList(),
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

class _CartTotal extends StatefulWidget {
  @override
  _CartTotalState createState() => _CartTotalState();
}

class _CartTotalState extends State<_CartTotal> {
  late String userID = FirebaseAuth.instance.currentUser!.uid;
  late String userMemberID = "Loading..";
  late int userPoints = 0;
  late int cartTotal = 0;
  late int userRemainPoints = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    userMemberID = await UserService().getUserMemberID(userID);
    userPoints = await UserService().getUserPoints(userID);
    userRemainPoints = userPoints;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<Cart>(
                builder: (context, cart, child) => Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Your current Points: '),
                                Text("$userPoints Points")
                              ],
                            ),
                          ),
                          Consumer<Cart>(
                            builder: (context, cart, child) {
                              return FutureBuilder<int>(
                                future: cart.getCartTotal(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text(
                                      'Error: ${snapshot.error}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    );
                                  } else {
                                    userRemainPoints -= snapshot.data as int;
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Total'),
                                          Text("${snapshot.data} Points")
                                        ],
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ElevatedButton(
                                onPressed: () {
                                  // add to userPurcase firebase
                                  UserPurchaseService()
                                      .purchaseItems(userID, cart.cartItems);
                                  // update points
                                  if (userRemainPoints > 0) {
                                    UserService().updateUserPoints(
                                        userMemberID, userRemainPoints);
                                    //clear all items in the cart and notify
                                    cart.clearCart();
                                    Navigator.pop(context);
                                    Navigator.pushNamed(context, '/cart');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Successfully claimed!'),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Failed to claimed. Please check if you have enough points.'),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  backgroundColor: Colors.deepOrange,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Claim',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                    )),
          ],
        ),
      ),
    );
  }
}
