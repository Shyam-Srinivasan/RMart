import 'package:flutter/material.dart';
import 'package:rmart/models/order_item.dart'; // Import the OrderItem model

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orders = [
      OrderItem(name: 'Sambar Rice', price: 80, quantity: 2, isPurchased: true),
      OrderItem(name: 'Veg Biriyani', price: 150, quantity: 3, isPurchased: false),
      OrderItem(name: 'Choola Poori', price: 100, quantity: 2, isPurchased: true),
      OrderItem(name: 'Chapati', price: 75, quantity: 5, isPurchased: false),
    ];

    final purchasedItems = orders.where((item) => item.isPurchased).toList();
    final pendingItems = orders.where((item) => !item.isPurchased).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(15.0),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTabIndicator('Purchased', 0),
              _buildTabIndicator('Pending', 1),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          OrdersView(title: 'Purchased', items: purchasedItems),
          OrdersView(title: 'Pending', items: pendingItems),
        ],
      ),
    );
  }

  Widget _buildTabIndicator(String label, int index) {
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _currentPage == index ? Colors.deepPurple : Colors.black,
              ),
            ),
            if (_currentPage == index)
              Container(
                height: 3,
                width: 50,
                color: Colors.deepPurple,
                margin: EdgeInsets.only(top: 4),
              ),
          ],
        ),
      ),
    );
  }
}

class OrdersView extends StatelessWidget {
  final String title;
  final List<OrderItem> items;

  OrdersView({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(item.name),
                    subtitle: Text('Price: ₹${item.price} x ${item.quantity}'),
                    trailing: Text('Total: ₹${(item.price * item.quantity).toInt()}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
