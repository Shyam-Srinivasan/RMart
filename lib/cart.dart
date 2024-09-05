import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rmart/qr_code_page.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late DatabaseReference _databaseRef;
  Map<String, Map<String, dynamic>> _cartItems = {};
  late StreamSubscription<DatabaseEvent> _streamSubscription;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _databaseRef = FirebaseDatabase.instance.ref();
    _activateListeners();
  }

  void _activateListeners() {
    _streamSubscription = _databaseRef
        .child('UserDatabase/UserID1/CartItems/')
        .onValue
        .listen((event) {
      final data = event.snapshot.value;

      if (data == null || data is! Map) {
        print('Error: Data is null or not a Map');
        return;
      }

      setState(() {
        _cartItems = Map<String, Map<String, dynamic>>.from(
          (data as Map).map(
                (key, value) => MapEntry(
              key,
              Map<String, dynamic>.from(value),
            ),
          ),
        );
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    // Filter only items with quantity > 0
    final filteredItems = _cartItems.entries
        .where((entry) => entry.value['quantity'] != null && entry.value['quantity'] > 0)
        .toList();

    // Calculate total amount and number of items
    double totalAmount = filteredItems.fold(
      0.0,
          (sum, entry) {
        final price = entry.value['price'] ?? 0.0;
        final quantity = entry.value['quantity'] ?? 0;
        return sum + (price * quantity);
      },
    );

    int totalItems = filteredItems.fold(
      0,
          (sum, entry) => sum + (entry.value['quantity'] ?? 0) as int,
    );

    // Prepare orderedItems list to pass to QrCodePage
    List<Map<String, dynamic>> orderedItems = filteredItems.map((entry) {
      final itemName = entry.key;
      final itemDetails = entry.value;
      return {
        'name': itemName,
        'price': itemDetails['price'],
        'quantity': itemDetails['quantity'],
      };
    }).toList();

    final isCartEmpty = filteredItems.isEmpty;

    void _updateItemInDatabase(String itemName, Map<String, dynamic> itemDetails) {
      // Assuming you have a reference to your Firebase Realtime Database
      DatabaseReference ref = FirebaseDatabase.instance.ref('UserDatabase/UserID1/CartItems/$itemName');

      // Update item in database
      ref.update({
        'quantity': itemDetails['quantity'],
      });
    }

    void _removeItemFromCart(String itemName) {
      // Remove item from local cart
      setState(() {
        _cartItems.remove(itemName);
      });

      // Also remove item from database
      DatabaseReference ref = FirebaseDatabase.instance.ref('UserDatabase/UserID1/CartItems/$itemName');
      ref.remove();
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        backgroundColor: Colors.white,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Divider(
            height: 4.0,
            thickness: 1,
            color: Color(0x61693BB8),
          ),
        ),
      ),
      body: _isLoading
        ? Center(
        child: Lottie.asset(
          'assets/img/DinnerLoading.json',  // Assuming this is your loading animation file
          width: 200,
          height: 200,
        ),
      )
      :isCartEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/img/EmptyCart.json',
                width: 350,
                height: 350,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              Text(
                "Your cart is empty",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),
              ),
            ],
          ),
        ),
      )
          : ListView.builder(
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final itemName = filteredItems[index].key;
          final itemDetails = filteredItems[index].value;

          final imagePath = 'assets/img/${itemName.replaceAll(' ', '')}.jpeg';

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(10),
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
              child: Row(
                children: [
                  // Image section
                  itemDetails['image'] != null
                      ? Image.asset(
                    imagePath,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    height: 80,
                    width: 80,
                    color: Colors.grey,
                    child: Center(
                      child: Text(
                        'No Image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Details section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          itemName ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Price: ₹${itemDetails['price']?.toStringAsFixed(2) ?? '0.00'}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Total: ₹${((itemDetails['price'] ?? 0) * (itemDetails['quantity'] ?? 0)).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Quantity controls
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (itemDetails['quantity'] != null && itemDetails['quantity'] > 1) {
                              itemDetails['quantity']--;
                              _updateItemInDatabase(itemName, itemDetails);
                            } else {
                              // Remove item from cart and database
                              _removeItemFromCart(itemName);
                            }
                          });
                        },
                        icon: Icon(Icons.remove),
                        color: Colors.white,
                        iconSize: 18,
                        padding: EdgeInsets.all(2),
                        constraints: BoxConstraints(),
                        splashRadius: 20,
                        splashColor: Colors.deepPurple,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                          shape: MaterialStateProperty.all(CircleBorder()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '${itemDetails['quantity'] ?? 0}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            itemDetails['quantity'] = (itemDetails['quantity'] ?? 0) + 1;
                            _updateItemInDatabase(itemName, itemDetails);
                          });
                        },
                        icon: Icon(Icons.add),
                        color: Colors.white,
                        iconSize: 18,
                        padding: EdgeInsets.all(2),
                        constraints: BoxConstraints(),
                        splashRadius: 20,
                        splashColor: Colors.deepPurple,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                          shape: MaterialStateProperty.all(CircleBorder()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      'Total Amount: ₹${totalAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 1),
                    child: Text(
                      'Number of Items: $totalItems',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  onPressed: isCartEmpty ? null : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QrCodePage(orderedItems: orderedItems, totalAmount: totalAmount),
                      ),
                    );
                  },
                  child: Text('Pay Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: Size(150, 50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
