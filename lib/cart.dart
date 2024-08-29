import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rmart/models/cart_items.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartItems = CartItems().cart_items_list;

    // Filter only items with quantity > 0
    final filteredItems = cartItems.entries
        .where((entry) => entry.value.quantity > 0)
        .toList();

    // Calculate total amount and number of items
    double totalAmount = filteredItems.fold(
      0.0,
          (sum, entry) => sum + (entry.value.price * entry.value.quantity),
    );
    int totalItems = filteredItems.fold(
      0,
          (sum, entry) => sum + entry.value.quantity,
    );

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
      body: filteredItems.isEmpty
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
                  Image.asset(
                    'assets/img/${itemName.replaceAll(' ', '')}.jpeg',
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 10),
                  // Details section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          itemName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Price: ₹${itemDetails.price}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Total: ₹${(itemDetails.price * itemDetails.quantity).toInt()}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Quantity controls
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (itemDetails.quantity > 1) {
                              itemDetails.quantity--;
                            } else {
                              // Remove item from cart if quantity is 0
                              cartItems.remove(itemName);
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
                          itemDetails.quantity.toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            itemDetails.quantity++;
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
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      'Total Amount: ₹${totalAmount.toInt()}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 2,
                  // ),
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
                  onPressed: () {
                    // Implement payment functionality
                  },
                  child: Text('Pay Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    fixedSize: Size(150, 50)
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
