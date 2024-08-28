import 'package:flutter/material.dart';
import 'package:rmart/models/CartItems.dart';

class AddToCartButton extends StatefulWidget {
  final String foodItem;
  AddToCartButton({required this.foodItem});

  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  late CartItem cartItem;
  bool _isClicked = false;

  @override
  void initState() {
    super.initState();
    cartItem = CartItems().cart_items_list[widget.foodItem]!;
    _isClicked = cartItem.quantity > 0;
  }

  void _handleClick() {
    setState(() {
      if (cartItem.quantity == 0) {
        cartItem.quantity = 1;
        _isClicked = true;
      } else {
        cartItem.quantity = 0;
        _isClicked = false;
      }
      print("Map: ${CartItems().cart_items_list[widget.foodItem]}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 100,
        height: 33,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(15),
        ),
        child: cartItem.quantity == 0
            ? TextButton(
          onPressed: _handleClick,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: EdgeInsets.zero,
          ),
          child: Text('Add', style: TextStyle(fontSize: 16)),
        )
            : Row(
          children: [
            Flexible(
              child: IconButton(
                onPressed: () {
                  setState(() {
                    if (cartItem.quantity > 0) {
                      cartItem.quantity--;
                      if (cartItem.quantity == 0) {
                        _isClicked = false;
                      }
                    }
                    print("Map: ${CartItems().cart_items_list}");
                  });
                },
                icon: Icon(Icons.remove, color: Colors.white, size: 24),
                padding: EdgeInsets.zero,
              ),
            ),
            Text(
              '${cartItem.quantity}',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Flexible(
              child: IconButton(
                onPressed: () {
                  setState(() {
                    cartItem.quantity++;
                    print("Map: ${CartItems().cart_items_list}");
                  });
                },
                icon: Icon(Icons.add, color: Colors.white, size: 24),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PopularItemsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartItems = CartItems().cart_items_list;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          children: cartItems.entries.map((entry) {
            final foodName = entry.key;
            final cartItem = entry.value;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 7),
              child: Container(
                width: 170,
                height: 225,
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
                    children: [
                      Expanded(
                        child: Container(
                          child: Image.asset(
                            "assets/img/${foodName.replaceAll(' ', '')}.jpeg", // Assuming the image names are based on the food names
                            height: 150,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
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
                            " $foodName",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10, left: 10),
                            child: Text(
                              "₹${cartItem.price.toInt()}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: AddToCartButton(foodItem: foodName),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
