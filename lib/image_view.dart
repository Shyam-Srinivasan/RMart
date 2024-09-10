// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
//
// class DisplayFirebaseImage extends StatefulWidget {
//   const DisplayFirebaseImage({Key? key}) : super(key: key);
//
//   @override
//   State<DisplayFirebaseImage> createState() => _DisplayFirebaseImageState();
// }
//
// class _DisplayFirebaseImageState extends State<DisplayFirebaseImage> {
//   String? _imageUrl;
//
//   @override
//   void initState() {
//     super.initState();
//     _getImageUrl();
//   }
//
//   Future<void> _getImageUrl() async {
//     try {
//       // Replace with your actual Firebase Storage path
//       final ref = FirebaseStorage.instance.refFromURL(
//           'gs://rec-mart.appspot.com/SambarRice.jpeg');
//       final downloadUrl = await ref.getDownloadURL();
//       setState(() {
//         _imageUrl = downloadUrl;
//       });
//     } catch (e) {
//       print('Error getting image URL: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Image from Firebase'),
//       ),
//       body: Center(
//         child: _imageUrl != null
//             ? Image.network(_imageUrl!)
//             : const CircularProgressIndicator(),
//       ),
//     );
//   }
// }
