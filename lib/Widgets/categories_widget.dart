import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoriesWidget extends StatefulWidget {
  final Function(String) onCategorySelected;

  const CategoriesWidget({super.key, required this.onCategorySelected});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  List<String> categoryNames = [];
  final _database = FirebaseDatabase.instance.ref();
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
        .child('AdminDatabase/Rec Cafe/Categories/')
        .onValue
        .listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      final List<String> categories = [];
      data.forEach((key, value) {
        categories.add(key);
      });
      setState(() {
        categoryNames = categories;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Row(
          children: [
            // images are used from local
            for (int i = 0; i < categoryNames.length; i++)
              _buildCategoryItem(
                  categoryNames[i], 'assets/img/${categoryNames[i]}.jpeg'),
          ],
        ),
      ),
    );
  }


  Widget _buildCategoryItem(String category, String imagePath) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () => widget.onCategorySelected(category),
        child: Container(
          padding: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                width: 170,
                height: 160,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 0),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
