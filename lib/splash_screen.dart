import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rmart/login_screen.dart';
import 'package:rmart/sign_in_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        // TODO Splash Screen to LoginPage()
        // MaterialPageRoute(builder: (_) => LoginPage()),
        // TODO Remove this line
        MaterialPageRoute(builder: (_)=>SignIn())
      );
      // TODO Remove this line
      /*Navigator.of(context).pushNamed('/home', arguments: {
        'name': 'Shyam Srinivasan',
        'email': '220701508@rajalakshmi.edu'
      });*/

    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 120, bottom: 80),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/img/Logo.jpeg",
                  width: 80, // Adjust the size as needed
                  height: 80,
                ),
                const SizedBox(width: 10), // Space between the logo and text
                const Expanded(
                  child: Text(
                    'Mart',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w900,
                    ),
                    overflow: TextOverflow.ellipsis, // Handle overflow
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
