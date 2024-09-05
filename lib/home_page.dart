import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'Widgets/categories_widget.dart';
import 'Widgets/popular_items_widget.dart';
import 'categories.dart';
import 'data_search.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulate a delay for loading animation
    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      _isLoading = false;
    });
  }

  void _onCategorySelected(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Categories(category: category),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final email = arguments['email'] ?? '';
    final name = arguments['name'] ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Stack(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 30,
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 4),
                Transform.translate(
                  offset: const Offset(0, -5),
                  child: const Text(
                    'Rec Cafe',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: const Offset(34.5, 20),
              child: InkWell(
                onTap: () {
                  print('Switch Shop');
                  Navigator.pushNamed(context, '/option');
                },
                child: const Text(
                  'Switch Shop',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: const Icon(Icons.person),
                color: Colors.deepPurple,
                iconSize: 30,
              );
            },
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Divider(
            height: 4.0,
            thickness: 1,
            color: Color(0x61693BB8),
          ),
        ),
      ),
      body: Stack(
        children: [
          if (_isLoading)
            Stack(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: const ModalBarrier(
                    dismissible: false,
                    color: Colors.black,
                  ),
                ),
                Center(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/img/DinnerLoading.json', width: 200, height: 200),
                        SizedBox(height: 20),
                        Text(
                          'Please wait...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          if (!_isLoading)
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: InkWell(
                      overlayColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchPage()),
                        );
                      },
                      child: Container(
                        height: 50.0,
                        width: 380.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.grey, width: 0.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset: const Offset(0, 0),
                              )
                            ]),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Image.asset('assets/img/Search.gif', height: 24, width: 24),
                            const SizedBox(width: 8.0),
                            const Expanded(
                              child: Text(
                                'What would you like to have?',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Categories",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Divider(
                        height: 20,
                        thickness: 1,
                        color: Color(0x61693BB8),
                      ),
                    ],
                  ),
                ),
                CategoriesWidget(
                  onCategorySelected: (category) => _onCategorySelected(context, category),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Popular",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Divider(
                        height: 20,
                        thickness: 1,
                        color: Color(0x61693BB8),
                      ),
                    ],
                  ),
                ),
                PopularItemsWidget(),
              ],
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          )
        ],
        onTap: (int index) {
          switch(index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/orders');
              break;
            case 2:
              Navigator.pushNamed(context, '/cart');
          }
        },
      ),
      endDrawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(name),
              accountEmail: Text(email),
              currentAccountPicture: const ClipOval(
                child: Image(
                  image: AssetImage('assets/img/Shyam_photo.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const ListTile(
              title: Text('Favorites'),
              leading: Icon(Icons.favorite),
            ),
            const ListTile(
              title: Text('Order History'),
              leading: Icon(Icons.history),
            ),
            const ListTile(
              title: Text('Feedback'),
              leading: Icon(Icons.feedback),
            ),
            const ListTile(
              title: Text('About Us'),
              leading: Icon(Icons.info),
            ),
            const ListTile(
              title: Text('Log out'),
              leading: Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}
