import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopOption extends StatefulWidget {
  const ShopOption({Key? key}) : super(key: key);

  @override
  State<ShopOption> createState() => _ShopOptionState();
}

class _ShopOptionState extends State<ShopOption> {
  bool _isLoading = false;

  Future<void> _saveShopName(String shopName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedShop', shopName);
  }

  void _navigateToHome(String shopName) async {
    setState(() {
      _isLoading = true;
    });

    // Simulate a delay for loading animation
    await Future.delayed(Duration(milliseconds: 500));

    // Save the selected shop
    await _saveShopName(shopName);

    // Navigate to home screen with selected shop
    Navigator.pushNamed(
      context,
      '/home',
      arguments: {
        'shop': shopName,
        'name': 'Shyam Srinivasan',
        'email': '220701508@rajalakshmi.edu'
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _navigateToHome('Rec Hut'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(180, 180),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(
                          color: Colors.deepPurple,
                          width: 2
                        ),
                        shadowColor: Colors.black.withOpacity(0.7),
                        elevation: 10,
                      ),
                      child: Text(
                        'Rec Hut',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => _navigateToHome('Rec Cafe'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(180, 180),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(
                            color: Colors.deepPurple,
                            width: 2
                        ),
                        shadowColor: Colors.black.withOpacity(0.7),
                        elevation: 10,
                      ),
                      child: Text(
                        'Rec Cafe',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _navigateToHome('Rec Mart'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(180, 180),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(
                            color: Colors.deepPurple,
                            width: 2
                        ),
                        shadowColor: Colors.black.withOpacity(0.7),
                        elevation: 10,
                      ),
                      child: Text(
                        'Rec Mart',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => _navigateToHome('Fresh Crush'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(180, 180),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(
                            color: Colors.deepPurple,
                            width: 2
                        ),
                        shadowColor: Colors.black.withOpacity(0.7),
                        elevation: 10,
                      ),
                      child: Text(
                        'Fresh Crush',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Select a Shop',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
