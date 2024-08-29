import 'package:flutter/material.dart';
import 'package:rmart/cart.dart';
import 'package:rmart/login_screen.dart';
import 'package:rmart/orders.dart';
import 'package:rmart/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
  const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: MyApp(),
  )
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "RMart",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white
      ),
      initialRoute: '/login',
      routes: {
        "/" : (context) => const SplashScreen(),
        "/orders" : (context) => OrdersPage(),
        "/cart" : (context) => CartPage(),
        "/login" : (context) => const LoginScreen(),
      },
    );
  }
}
