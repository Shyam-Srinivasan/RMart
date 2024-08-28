import 'package:flutter/material.dart';
import 'package:rmart/models/CartItems.dart';
import 'package:rmart/Widgets/PopularItemsWidget.dart';// Make sure to import the AddToCartButton

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _query = '';
  final List<String> _items = [
    'Sambar Rice',
    'Idli',
    'Pongal',
    'Choola Poori',
    'Chapati',
    'Dosa',
    'Veg Biriyani',
    'Veg Noodles',
    'Veg Rice',
    'Veg Pasta',
    'Egg Noodles',
    'Egg Rice',
    'Egg Pasta',
  ];
  final List<String> _recentItems = ['Sambar Rice', 'Chapati'];

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
        ? _recentItems
        : _items.where((item) => item.toLowerCase().contains(_query.toLowerCase())).toList();

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
                  "assets/img/${item.replaceAll(' ', '')}.jpeg", // Assuming image names are based on food names
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
                      item,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AddToCartButton(foodItem: item), // Add the AddToCartButton here
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
