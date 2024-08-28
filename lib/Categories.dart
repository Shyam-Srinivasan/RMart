import 'package:flutter/material.dart';
import 'package:rmart/Widgets/PopularItemsWidget.dart';
import 'package:rmart/models/CartItems.dart'; // Import the CartItems class

class Categories extends StatefulWidget {
  final String category;

  const Categories({super.key, required this.category});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  late final PageController _pageController;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _getPageIndexFromCategory(widget.category),
    );
    _pageController.addListener(_onPageChanged);
    _selectedCategory = widget.category;
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    final pageIndex = _pageController.page?.round() ?? 0;
    setState(() {
      _selectedCategory = _getCategoryFromIndex(pageIndex);
    });
  }

  void _navigateToPage(int pageIndex, String category) {
    _pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _selectedCategory = category;
    });
  }

  String _getCategoryFromIndex(int index) {
    switch (index) {
      case 1:
        return 'BreakFast';
      case 2:
        return 'Lunch';
      case 3:
        return 'Snacks';
      case 4:
        return 'Beverages';
      case 5:
        return 'IceCreams';
      default:
        return 'All';
    }
  }

  int _getPageIndexFromCategory(String category) {
    switch (category) {
      case 'BreakFast':
        return 1;
      case 'Lunch':
        return 2;
      case 'Snacks':
        return 3;
      case 'Beverages':
        return 4;
      case 'IceCreams':
        return 5;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Column(
          children: [
            AppBar(
              leading: Padding(
                padding: EdgeInsets.only(left: 0, top: 8),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                ),
              ),
              backgroundColor: Colors.white,
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.only(left: 0, top: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryButton('All', 0),
                        _buildCategoryButton('BreakFast', 1),
                        _buildCategoryButton('Lunch', 2),
                        _buildCategoryButton('Snacks', 3),
                        _buildCategoryButton('Beverages', 4),
                        _buildCategoryButton('IceCreams', 5),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 3),
            Container(
              color: Color(0x61693BB8),
              height: 1.0,
            ),
          ],
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: 6,
        itemBuilder: (context, index) {
          return _buildFoodGrid(_getCategoryFromIndex(index));
        },
      ),
    );
  }

  Widget _buildCategoryButton(String title, int pageIndex) {
    bool isSelected = _selectedCategory == title;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: () => _navigateToPage(pageIndex, title),
        child: Text(title),
        style: ElevatedButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : Colors.deepPurple,
          backgroundColor: isSelected ? Colors.deepPurple : Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodGrid(String category) {
    final cartItems = CartItems();

    List<Map<String, dynamic>> items;
    if (category == 'All') {
      items = [
        ...cartItems.categoryItems['BreakFast']!,
        ...cartItems.categoryItems['Lunch']!,
        ...cartItems.categoryItems['Snacks']!,
        ...cartItems.categoryItems['Beverages']!,
        ...cartItems.categoryItems['IceCreams']!,
      ];
    } else {
      items = cartItems.categoryItems[category] ?? [];
    }

    return GridView.builder(
      padding: EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 25,
        mainAxisSpacing: 25,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final itemName = item['name'];
        final itemPrice = item['price'];
        final itemImage = item['image'];

        return Container(
          width: 170,
          height: 225, // Ensure this matches the height in PopularItemsWidget
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensure content is spaced evenly
              children: [
                Expanded(
                  child: Image.asset(
                    itemImage,
                    height: 150,
                    width: 200,
                    fit: BoxFit.cover, // Ensure the image covers the full height
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Image.asset(
                        "assets/img/vegan.png",
                        height: 25,
                        width: 25,
                      ),
                    ),
                    Text(
                      " $itemName",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10, left: 10),
                      child: Text(
                        "₹${itemPrice.toInt()}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AddToCartButton(foodItem: itemName),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}
