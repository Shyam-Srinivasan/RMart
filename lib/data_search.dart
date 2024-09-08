import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rmart/add_to_cart.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Ensure the import is correct

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _query = '';
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> _items = [];
  late StreamSubscription<DatabaseEvent> _streamSubscription;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<String?> getSelectedShop() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedShop');
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  void _fetchData() async{
    String? shopName = await getSelectedShop();
    _streamSubscription = _database
        .child('AdminDatabase/$shopName/Categories')
        .onValue
        .listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      final List<Map<String, dynamic>> items = [];

      data.forEach((categoryKey, categoryValue) {
        final categoryMap = categoryValue as Map<dynamic, dynamic>;

        categoryMap.forEach((itemKey, itemValue) {
          final item = {
            'name': itemValue['name'] ?? itemKey,
            'price': itemValue['price'] ?? 0.0,
            'quantity': itemValue['quantity'] ?? 0,
            'image': itemValue['image'] ?? 'assets/img/default.jpeg', // Default image if not available
          };

          items.add(item);
        });
      });

      setState(() {
        _items = items;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.0), // Increased height for better spacing
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.white,
              title: Transform(
                transform: Matrix4.translationValues(-18.0, -3, 0.0), // Move the search bar slightly left
                child: Container(
                  margin: EdgeInsets.only(top: 8.0), // Margin for spacing
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.grey, width: 0.5), // Border color and width
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 0, // Spread of shadow
                          blurRadius: 6, // Blur intensity
                          offset: Offset(0, 0), // Offset of shadow
                        ),
                      ],
                    ),
                    child: TextField(
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {
                          _query = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
                        border: InputBorder.none, // Remove default border
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      ),
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.deepPurple.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8.0, // Space between the search bar and the divider
            ),
            Divider(
              height: 1.0, // Height of the divider
              thickness: 1, // Thickness of the divider
              color: Colors.grey[300], // Color of the divider
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white, // Set the body background color to white
        child: ListView(
          children: _buildSuggestions(),
        ),
      ),
    );
  }

  List<Widget> _buildSuggestions() {
    final suggestions = _query.isEmpty
        ? _items
        : _items.where((item) => item['name'].toLowerCase().contains(_query.toLowerCase())).toList();

    return suggestions.map((item) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: Container(
          width: double.infinity,
          height: 200, // Adjusted height
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  item['image'], // Load image from URL
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AddToCartButton(
                      foodItem: {
                        'name': item['name'],
                        'price': item['price'],
                        'quantity': item['quantity'],
                        'image': item['image'],
                      },
                    ), // Add the AddToCartButton here
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
