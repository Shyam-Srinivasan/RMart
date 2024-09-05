import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rmart/add_to_cart.dart'; // Import the add_to_cart.dart

class PopularItemsWidget extends StatefulWidget {
  @override
  _PopularItemsWidgetState createState() => _PopularItemsWidgetState();
}

class _PopularItemsWidgetState extends State<PopularItemsWidget> {
  List<Map<String, dynamic>> popularItems = [];
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  late StreamSubscription<DatabaseEvent> _streamSubscription;

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  void _activateListeners() {
    _streamSubscription = _database
        .child('AdminDatabase/Rec Cafe/Popular')
        .onValue
        .listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      final List<Map<String, dynamic>> items = [];
      data.forEach((key, value) {
        items.add({
          'name': value['name'] ?? key,
          'price': value['price'] ?? 0.0,
          'quantity': value['quantity'] ?? 0,
          'image': value['image'] ?? 'assets/img/default.jpeg', // Provide a default image if not available
        });
      });
      setState(() {
        popularItems = items;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          children: popularItems.map((item) {
            final imagePath = item['image'];
            final foodName = item['name'];
            final price = item['price'];
            final quantity = item['quantity'];

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 7),
              child: Container(
                width: 170,
                height: 225,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          child: Image.asset(
                            imagePath,
                            height: 150,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            " $foodName",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10, left: 10),
                            child: Text(
                              "₹${price.toInt()}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: AddToCartButton(
                                foodItem: {
                                  'name': foodName,
                                  'price': price,
                                  'quantity': quantity,
                                  'image': imagePath,
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
