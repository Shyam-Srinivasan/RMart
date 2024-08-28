import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget {
  final Function(String) onCategorySelected;

  const CategoriesWidget({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Row(
          children: [
            _buildCategoryItem('BreakFast', 'assets/img/BreakFastHD.jpeg'),
            _buildCategoryItem('Lunch', 'assets/img/SambarRice.jpeg'),
            _buildCategoryItem('Snacks', 'assets/img/SnacksHD.jpeg'),
            _buildCategoryItem('Beverages', 'assets/img/BeveragesHD.jpeg'),
            _buildCategoryItem('IceCreams', 'assets/img/IcecreamsHD.jpeg'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String category, String imagePath) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () => onCategorySelected(category),
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
