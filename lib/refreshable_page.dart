import 'package:flutter/material.dart';

class RefreshablePage extends StatefulWidget {
  @override
  _RefreshablePageState createState() => _RefreshablePageState();
}

class _RefreshablePageState extends State<RefreshablePage> {
  Future<void> _refreshData() async {
    // Simulate a network request or data refresh
    await Future.delayed(Duration(seconds: 2));
    // Update your data here
    setState(() {
      // Refresh the state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pull to Refresh Example'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          itemCount: 20, // Number of items
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Item $index'),
            );
          },
        ),
      ),
    );
  }
}
