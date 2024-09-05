import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;

  const LoadingOverlay({Key? key, required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
      color: Colors.white.withOpacity(0.8),
      child: Center(
        child: Lottie.asset('assets/img/DinnerLoading.json'), // Your loading animation
      ),
    )
        : SizedBox.shrink();
  }
}
