import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddToCartButton extends StatefulWidget {
  final Map<String, dynamic> foodItem;

  const AddToCartButton({super.key, required this.foodItem});

  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  late DatabaseReference _databaseRef;
  late StreamSubscription<DatabaseEvent> _streamSubscription;
  int quantity = 0;
  bool _isClicked = false;

  @override
  void initState() {
    super.initState();
    _databaseRef = FirebaseDatabase.instance.ref();
    _activateListeners();
  }

  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      print('No user is signed in');
      return null; // Handle the case when no user is signed in
    }
  }

  // Fetch real-time data and update the quantity in the UI
  void _activateListeners() {
    String? userId = getCurrentUserId(); // Get the userId
    if (userId != null) {
      _streamSubscription = _databaseRef
          .child('UserDatabase/$userId/CartItems/${widget.foodItem['name']}/quantity')
          .onValue
          .listen((event) {
        if (event.snapshot.value != null) {
          setState(() {
            quantity = int.parse(event.snapshot.value.toString());
            _isClicked = quantity > 0;
          });
        } else {
          // If the item is removed from the cart, reset quantity
          setState(() {
            quantity = 0;
            _isClicked = false;
          });
        }
      });
    }
  }

  void _updateDatabase() {
    String? userId = getCurrentUserId(); // Get the userId
    if (userId != null) {
      _databaseRef.child('UserDatabase/$userId/CartItems/${widget.foodItem['name']}').update({
        'name': widget.foodItem['name'],
        'price': widget.foodItem['price'],
        'quantity': quantity,
        'image': widget.foodItem['image'],
      });
    }
  }

  void _deleteDatabase(){
    String? userId = getCurrentUserId(); // Get the userId
    if (userId != null) {
      _databaseRef.child('UserDatabase/$userId/CartItems/${widget.foodItem['name']}').remove();
    }
  }

  void _handleClick() {
    setState(() {
      if (quantity == 0) {
        quantity = 1;
        _isClicked = true;
        _updateDatabase();
      } else {
        quantity = 0;
        _isClicked = false;
        _deleteDatabase();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 5),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 100,
        height: 33,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(15),
        ),
        child: quantity == 0
            ? TextButton(
          onPressed: _handleClick,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: EdgeInsets.zero,
          ),
          child: const Text('Add', style: TextStyle(fontSize: 16)),
        )
            : Row(
          children: [
            Flexible(
              child: IconButton(
                onPressed: () {
                  setState(() {
                    if (quantity > 0) {
                      quantity--;
                      if (quantity == 0) {
                        _isClicked = false;
                        _deleteDatabase();
                      }
                      _updateDatabase();
                    }
                  });
                },
                icon: const Icon(Icons.remove, color: Colors.white, size: 24),
                padding: EdgeInsets.zero,
              ),
            ),
            Text(
              '$quantity',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            Flexible(
              child: IconButton(
                onPressed: () {
                  setState(() {
                    quantity++;
                    _isClicked = true;
                    _updateDatabase();
                  });
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 24),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}
