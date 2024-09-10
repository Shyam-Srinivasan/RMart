import 'dart:async';
import 'package:rmart/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _activateListeners();
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

  void _activateListeners() async{
    String? shopName = await getSelectedShop();
    _streamSubscription = _database
        .child('AdminDatabase/$shopName/Categories/')
        .onValue
        .listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      final List<String> categories = [];
      data.forEach((key, value) {
        categories.add(key);
      });
      setState(() {
        categoryNames = categories;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: _isLoading
          ? ShimmerEffect(width: 170, height: 225)
        : Row(
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
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5),
                  topLeft: Radius.circular(5)
                ),
                child: Image.asset(
                  imagePath,
                  width: 170,
                  height: 160,
                  fit: BoxFit.cover,
                ),
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
