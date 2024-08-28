import 'package:flutter/material.dart';
import 'package:rmart/splash_screen.dart';



void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: MyApp(),

));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Food App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white
      ),
      routes: {
        "/" : (context) => SplashScreen(),
      },
    );
  }
}
