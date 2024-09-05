// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:rmart/Widgets/popular_items_widget.dart';
//
// class Categories extends StatefulWidget {
//   final String category;
//
//   const Categories({super.key, required this.category});
//
//   @override
//   State<Categories> createState() => _CategoriesState();
// }
//
// class _CategoriesState extends State<Categories> {
//   late final PageController _pageController;
//   late DatabaseReference _databaseRef;
//   Map<String, List<Map<String, dynamic>>> _categoryItems = {};
//   List<String> _categories = [];
//   late StreamSubscription<DatabaseEvent> _streamSubscription;
//   String _selectedCategory = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _databaseRef = FirebaseDatabase.instance.ref();
//     _pageController = PageController(
//       initialPage: _getPageIndexFromCategory(widget.category),
//     );
//     _pageController.addListener(_onPageChanged);
//     _selectedCategory = widget.category;
//     _activateListeners();
//   }
//
//   @override
//   void dispose() {
//     _streamSubscription.cancel();
//     _pageController.removeListener(_onPageChanged);
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   void _activateListeners() {
//     _streamSubscription = _databaseRef
//         .child('AdminDatabase/Rec Cafe/Categories/')
//         .onValue
//         .listen((event) {
//       final data = event.snapshot.value;
//       print('Data received: $data');
//
//       if (data == null || data is! Map) {
//         // Handle the case where data is null or not a Map
//         print('Error: Data is null or not a Map');
//         return;
//       }
//
//       final Map<String, List<Map<String, dynamic>>> categoryItems = {};
//       final List<String> categories = [];
//
//       (data as Map<dynamic, dynamic>).forEach((key, value) {
//         print('Processing category: $key');
//         final categoryName = key as String;
//         categories.add(categoryName);
//
//         final items = (value as Map<dynamic, dynamic>).entries.map((e) {
//           final itemData = e.value as Map<dynamic, dynamic>;
//           return {
//             'name': itemData['name'],
//             'price': itemData['price'],
//             'image': itemData['image'],
//             'quantity': itemData['quantity'],
//           };
//         }).toList();
//
//         categoryItems[categoryName] = items;
//       });
//
//       setState(() {
//         _categoryItems = categoryItems;
//         _categories = categories;
//         _selectedCategory = widget.category.isEmpty ? categories.first : widget.category;
//         _pageController.jumpToPage(_getPageIndexFromCategory(_selectedCategory));
//       });
//     });
//   }
//
//   void _onPageChanged() {
//     final pageIndex = _pageController.page?.round() ?? 0;
//     setState(() {
//       _selectedCategory = _getCategoryFromIndex(pageIndex);
//     });
//   }
//
//   void _navigateToPage(int pageIndex, String category) {
//     _pageController.animateToPage(
//       pageIndex,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//     setState(() {
//       _selectedCategory = category;
//     });
//   }
//
//   String _getCategoryFromIndex(int index) {
//     if (index >= 0 && index < _categories.length) {
//       return _categories[index];
//     }
//     return 'All';
//   }
//
//   int _getPageIndexFromCategory(String category) {
//     final index = _categories.indexOf(category);
//     return index != -1 ? index : 0;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(80),
//         child: Column(
//           children: [
//             AppBar(
//               leading: Padding(
//                 padding: const EdgeInsets.only(left: 0, top: 8),
//                 child: IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: const Icon(Icons.arrow_back),
//                 ),
//               ),
//               backgroundColor: Colors.white,
//               title: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 0, top: 8),
//                   child: Row(
//                     children: _categories.map((category) {
//                       final isSelected = _selectedCategory == category;
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         child: ElevatedButton(
//                           onPressed: () => _navigateToPage(_categories.indexOf(category), category),
//                           style: ElevatedButton.styleFrom(
//                             foregroundColor: isSelected ? Colors.white : Colors.deepPurple,
//                             backgroundColor: isSelected ? Colors.deepPurple : Colors.white,
//                             elevation: 5,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                           ),
//                           child: Text(category),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 3),
//             Container(
//               color: const Color(0x61693BB8),
//               height: 1.0,
//             ),
//           ],
//         ),
//       ),
//       body: PageView.builder(
//         controller: _pageController,
//         itemCount: _categories.length,
//         itemBuilder: (context, index) {
//           return _buildFoodGrid(_categories[index]);
//         },
//       ),
//     );
//   }
//
//   Widget _buildFoodGrid(String category) {
//     final items = category == 'All'
//         ? _categoryItems.values.expand((e) => e).toList()
//         : _categoryItems[category] ?? [];
//
//     return GridView.builder(
//       padding: const EdgeInsets.all(20),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 25,
//         mainAxisSpacing: 25,
//       ),
//       itemCount: items.length,
//       itemBuilder: (context, index) {
//         final item = items[index];
//         final itemName = item['name'];
//         final itemPrice = item['price'];
//         final itemImage = item['image'];
//
//         return Container(
//           width: 170,
//           height: 225, // Ensure this matches the height in PopularItemsWidget
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.5),
//                 spreadRadius: 3,
//                 blurRadius: 10,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensure content is spaced evenly
//               children: [
//                 Expanded(
//                   child: Image.asset(
//                     itemImage,
//                     height: 150,
//                     width: 200,
//                     fit: BoxFit.cover, // Ensure the image covers the full height
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       " $itemName",
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 10, left: 10),
//                       child: Text(
//                         "₹${itemPrice.toInt()}",
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: AddToCartButton(foodItem: itemName),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
