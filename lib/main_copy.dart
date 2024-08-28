import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        backgroundColor: Colors.white,
        elevation: 1,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTabIndicator('Purchased', 0),
              SizedBox(width: 20),
              _buildTabIndicator('Pending', 1),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          _buildOrdersList('Purchased'),
          _buildOrdersList('Pending'),
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

  Widget _buildOrdersList(String status) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      itemCount: 10, // Replace with actual count
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16.0),
            title: Text('$status Item $index', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Details for $status Item $index'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
          ),
        );
      },
    );
  }
}
