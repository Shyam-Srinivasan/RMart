import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rmart/shop_option.dart';
import 'firebase_options.dart';
import 'login_screen.dart';
import 'home_page.dart';
import 'cart.dart';
import 'orders.dart';
import 'splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "RMart",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/auth': (context) => AuthGate(),
        '/orders': (context) => OrdersPage(),
        '/cart': (context) => CartPage(),
        '/login': (context) => LoginPage(),
        '/option': (context) => ShopOption(),
        '/home': (context) => Homepage(),
      },
    );
  }
}

class AuthGate extends StatefulWidget {
  @override
  _AuthGateState createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late Future<bool> _loginCheck;

  @override
  void initState() {
    super.initState();
    _loginCheck = _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loginCheck,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.data == true) {
            return Homepage(); // Navigate to home page
          } else {
            return LoginPage(); // Navigate to login page
          }
        }
      },
    );
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool('loggedIn') ?? false;
    return loggedIn;
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Perform login logic here (e.g., Firebase Authentication)
            // On successful login, set the loggedIn flag to true
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('loggedIn', true);

            // Navigate to home page
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Text('Login'),
        ),
      ),
    );
  }
}
