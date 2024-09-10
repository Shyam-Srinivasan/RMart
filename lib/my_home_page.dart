// import 'dart:async';
//
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
//
// class ReadExample extends StatefulWidget {
//   const ReadExample({Key? key}) : super(key: key);
//
//   @override
//   State<ReadExample> createState() => _ReadExampleState();
// }
//
// class _ReadExampleState extends State<ReadExample> {
//   String _displayText = 'Result goes here';
//   final _database = FirebaseDatabase.instance.ref();
//   String _path = 'path for image';
//   late StreamSubscription _foodItemStream;
//
//   @override
//   void initState() {
//     super.initState();
//     _activateListeners();
//   }
//
//   void _activateListeners() {
//     _foodItemStream = _database
//         .child("AdminDatabase")
//         .child('Rec Cafe')
//         .child('Categories')
//         .child('Lunch')
//         .child('Sambar Rice')
//         .child('image')
//         .onValue
//         .listen((event) {
//       final String description = event.snapshot.value as String;
//       setState(() {
//         _displayText = 'Today\'s Special is $description';
//         _path = description;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Read Example'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 15),
//           child: Column(
//             children: [
//               Text(_displayText),
//               Image.asset(_path)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void deactivate() {
//     _foodItemStream.cancel();
//     super.deactivate();
//   }
// }
