import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:rmart/qr_code_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late DatabaseReference _databaseRef;
  Map<String, Map<String, dynamic>> _cartItems = {};
  late StreamSubscription<DatabaseEvent> _cartStreamSubscription;
  late StreamSubscription<DatabaseEvent> _adminStreamSubscription;
  Map<String, dynamic> _adminData = {};
  late StreamSubscription<DatabaseEvent> _streamSubscription;
  bool _isLoading = true;
  String uniqueKey = '';

  @override
  void initState() {
    super.initState();
    _databaseRef = FirebaseDatabase.instance.ref();
    _activateListeners();
    _fetchAdminData();
  }

  Future<String?> getSelectedShop() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedShop');
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

  void _activateListeners() {
    String? userId = getCurrentUserId(); // Get the userId
    _cartStreamSubscription = _databaseRef
        .child('UserDatabase/$userId/CartItems/')
        .onValue
        .listen((event) {
      final data = event.snapshot.value;

      if (data == null || data is! Map) {
        print('Error: Data is null or not a Map');
        // Update the state to show an empty cart UI
        setState(() {
          _cartItems = {}; // Clear the cart
          _isLoading = false; // Stop loading
        });
        return;
      }

      setState(() {
        _cartItems = Map<String, Map<String, dynamic>>.from(
          (data as Map).map(
                (key, value) => MapEntry(
              key,
              Map<String, dynamic>.from(value),
            ),
          ),
        );
        _isLoading = false; // Stop loading
      });
    });
  }

  void _activateAdminListener() async {
    String? shopName = await getSelectedShop();
    _adminStreamSubscription = _databaseRef
        .child('AdminDatabase/$shopName/Categories')
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        setState(() {
          _adminData = Map<String, dynamic>.from(data as Map);
        });
      } else {
        setState(() {
          _adminData = {};
        });
      }
    });
  }
  Future<void> _fetchAdminData() async {
    String? shopName = await getSelectedShop();
    if (shopName != null) {
      DatabaseEvent event = await _databaseRef.child('AdminDatabase/$shopName/Categories').once();
      if (event.snapshot.value != null && event.snapshot.value is Map) {
        setState(() {
          _adminData = Map<String, dynamic>.from(event.snapshot.value as Map);
        });
        _activateAdminListener(); // Start listening to admin data changes
      } else {
        setState(() {
          _adminData = {};
        });
      }
    }
  }

  /*Future<void> _loadOrderData() async{
    String? shopName = await getSelectedShop();
    String? userId = getCurrentUserId(); // Get the userId
    _databaseRef.child('UserDatabase').child(userId).child('OrderedList').child(orderId).child({
      'isPurchased': false,
      'shop': shopName,
      'timestamp': timestampe,
      'totalAmount': totalAmount,
      'uniqueKey': uniqueKey,
      'orderItems': {
        'itemcount': {
          'name': itemName,
          'price': itemPrice,
          'quantity': itemQuantity,
    },
        'itemcount': {
          'name': itemName,
          'price': itemPrice,
          'quantity': itemQuantity,
        }
    }
    })

  }*/

  Future<void> _loadData() async {
    // Simulate a delay for loading animation
    await Future.delayed(Duration(milliseconds: 500));


    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _handleRefresh() async{
    setState(() {
      _isLoading = true;
    });
    await _loadData();
    return await Future.delayed(Duration(milliseconds: 800));
    setState(() {
      false;
    });
  }

  Future<void> _loadOrderData(double totalAmount, List<Map<String, dynamic>> orderedItems) async {
    String? userId = getCurrentUserId(); // Get the userId
    String? shopName = await getSelectedShop();
    String? orderId = Uuid().v4().replaceAll('-', '').substring(0,20);
    String? uniqueKey = Uuid().v4();
    final timestamp = DateTime.now().toString();

    _databaseRef.child('UserDatabase/$userId/OrderedList/$orderId').set({
      'shop': shopName,
      'isPurchased': false,
      'timestamp': timestamp,
      'totalAmount': totalAmount,
      'orderItems': orderedItems,
      'uniqueKey': uniqueKey,
    });

    _databaseRef.child('AdminDatabase/$shopName/UserPurchasedItems/$uniqueKey').set({
      'shop': shopName,
      'isPurchased': false,
      'timestamp': timestamp,
      'totalAmount': totalAmount,
      'orderItems': orderedItems,
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrCodePage(
          totalAmount: totalAmount,
          orderedItems: orderedItems,
          uniqueKey: uniqueKey,
        ),
      ),
    );
  }



  @override
  void dispose() {
    _cartStreamSubscription.cancel();
    _adminStreamSubscription.cancel();
    super.dispose();
  }

  void _showOutOfStockAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Out of Stock'),
        content: Text('Some items in your cart are out of stock. Please remove them to proceed.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Filter only items with quantity > 0
    final filteredItems = _cartItems.entries
        .where((entry) => entry.value['quantity'] != null && entry.value['quantity'] > 0)
        .toList();

    // Calculate total amount and number of items
    double totalAmount = filteredItems.fold(
      0.0,
          (sum, entry) {
        final price = entry.value['price'] ?? 0.0;
        final quantity = entry.value['quantity'] ?? 0;
        return sum + (price * quantity);
      },
    );

    int totalItems = filteredItems.fold(
      0,
          (sum, entry) => sum + (entry.value['quantity'] ?? 0) as int,
    );

    // Prepare orderedItems list to pass to QrCodePage
    List<Map<String, dynamic>> orderedItems = filteredItems.map((entry) {
      final itemName = entry.key;
      final itemDetails = entry.value;
      return {
        'name': itemName,
        'price': itemDetails['price'],
        'quantity': itemDetails['quantity'],
      };
    }).toList();

    final isCartEmpty = filteredItems.isEmpty;

    void _updateItemInDatabase(String itemName, Map<String, dynamic> itemDetails) {
      String? userId = getCurrentUserId(); // Get the userId
      // Assuming you have a reference to your Firebase Realtime Database
      DatabaseReference ref = FirebaseDatabase.instance.ref('UserDatabase/$userId/CartItems/$itemName');

      // Update item in database
      ref.update({
        'quantity': itemDetails['quantity'],
      });
    }

    void _removeItemFromCart(String itemName) {
      String? userId = getCurrentUserId(); // Get the userId
      // Remove item from local cart
      setState(() {
        _cartItems.remove(itemName);
      });

      // Also remove item from database
      DatabaseReference ref = FirebaseDatabase.instance.ref('UserDatabase/$userId/CartItems/$itemName');
      ref.remove();
    }

    bool _isOutOfStock(String itemName) {
      for (var category in _adminData.values) {
        if (category[itemName] != null && category[itemName]['quantity'] == 0) {
          return true; // Item is out of stock
        }
      }
      return false; // Item is in stock
    }

    bool hasOutOfStockItems() {
      return filteredItems.any((entry) => _isOutOfStock(entry.key));
    }



    void _removeOutOfStockItems() {
      final outOfStockItems = filteredItems.where((entry) => _isOutOfStock(entry.key)).toList();
      for (var entry in outOfStockItems) {
        _removeItemFromCart(entry.key);
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        backgroundColor: Colors.white,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Divider(
            height: 4.0,
            thickness: 1,
            color: Color(0x61693BB8),
          ),
        ),
      ),

      body: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        color:Colors.deepPurple,
        backgroundColor: Colors.deepPurple[200],
        animSpeedFactor: 2,
        springAnimationDurationInMilliseconds: 500,

        showChildOpacityTransition: false,
        child: Stack(
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
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 300),
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
                    ),
                  ],
                ),
              if (!_isLoading)
                isCartEmpty
                    ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/img/EmptyCart.json',
                          width: 350,
                          height: 350,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Your cart is empty",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final itemName = filteredItems[index].key;
                    final itemDetails = filteredItems[index].value;

                    final imagePath = 'assets/img/${itemName.replaceAll(' ', '')}.jpeg';
                    final isOutOfStock = _isOutOfStock(itemName);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.all(10),
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
                        child: Row(
                          children: [
                            // Image section
                            itemDetails['image'] != null
                                ? Image.asset(
                              imagePath,
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            )
                                : Container(
                              height: 80,
                              width: 80,
                              color: Colors.grey,
                              child: Center(
                                child: Text(
                                  'No Image',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            // Details section
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    itemName ?? 'Unknown',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Price: ₹${itemDetails['price']?.toStringAsFixed(2) ?? '0.00'}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Total: ₹${((itemDetails['price'] ?? 0) * (itemDetails['quantity'] ?? 0)).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            isOutOfStock
                                ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0),
                                  child: Text(
                                    'Out of Stock',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _removeItemFromCart(itemName);
                                    });
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            )
                                :Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (itemDetails['quantity'] != null && itemDetails['quantity'] > 1) {
                                        itemDetails['quantity']--;
                                        _updateItemInDatabase(itemName, itemDetails);
                                      } else {
                                        // Remove item from cart and database
                                        _removeItemFromCart(itemName);
                                      }
                                    });
                                  },
                                  icon: Icon(Icons.remove),
                                  color: Colors.white,
                                  iconSize: 18,
                                  padding: EdgeInsets.all(2),
                                  constraints: BoxConstraints(),
                                  splashRadius: 20,
                                  splashColor: Colors.deepPurple,
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                                    shape: MaterialStateProperty.all(CircleBorder()),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    '${itemDetails['quantity'] ?? 0}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      itemDetails['quantity'] = (itemDetails['quantity'] ?? 0) + 1;
                                      _updateItemInDatabase(itemName, itemDetails);
                                    });
                                  },
                                  icon: Icon(Icons.add),
                                  color: Colors.white,
                                  iconSize: 18,
                                  padding: EdgeInsets.all(2),
                                  constraints: BoxConstraints(),
                                  splashRadius: 20,
                                  splashColor: Colors.deepPurple,
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                                    shape: MaterialStateProperty.all(CircleBorder()),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ]
        ),
      ),
      bottomNavigationBar: filteredItems.isNotEmpty
          ?BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      'Total Amount: ₹${totalAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 1),
                    child: Text(
                      'Number of Items: $totalItems',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  onPressed: hasOutOfStockItems()
                      ? () {
                    // Show alert if there are out-of-stock items
                    _showOutOfStockAlert();
                  }
                      : (isCartEmpty || totalAmount == 0)
                      ? null
                      : () {
                    _loadOrderData(totalAmount, orderedItems);
                  },
                  child: Text('Pay Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: Size(150, 50),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          : SizedBox.shrink(),
    );
  }

}