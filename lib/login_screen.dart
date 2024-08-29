import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home_page.dart';
import 'text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool otpSent = false;
  bool loading = false;
  String? verificationId;

  // Mock function to send OTP, replace with your OTP service endpoint
  Future<void> sendOtp(String email) async {
    // Mock API call
    final response = await http.post(
      Uri.parse('https://your-otp-service.com/send-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        otpSent = true;
      });
    } else {
      throw Exception('Failed to send OTP');
    }
  }

  void _sendOtp() async {
    if (EmailValidator.validate(emailController.text) &&
        emailController.text.endsWith('@rajalakshmi.edu.in')) {
      setState(() {
        loading = true;
      });
      try {
        await sendOtp(emailController.text);
        setState(() {
          loading = false;
          otpSent = true;
        });
      } catch (e) {
        setState(() {
          loading = false;
          otpSent = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid REC email address.')),
      );
    }
  }

  void _verifyOtp() async {
    // Mock verification
    if (otpController.text == '123456') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: height / 2.7,
                child: Image.asset("assets/img/Login.json"),
              ),
              TextFieldInput(
                textEditingController: nameController,
                hintText: "Enter your Name",
                icon: Icons.person,
              ),
              TextFieldInput(
                textEditingController: emailController,
                hintText: "Enter your college email",
                icon: Icons.email,
              ),
              if (otpSent)
                TextFieldInput(
                  textEditingController: otpController,
                  hintText: "Enter OTP",
                  icon: Icons.lock,
                ),
              if (!otpSent)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: _sendOtp,
                      child: Text(
                        "Send OTP",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              if (otpSent)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: _sendOtp,
                      child: Text(
                        "Resend OTP",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              InkWell(
                onTap: otpSent ? _verifyOtp : _sendOtp,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Colors.blue,
                    ),
                    child: Text(
                      otpSent ? "Verify OTP" : "Log In",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height / 15),
            ],
          ),
        ),
      ),
    );
  }
}
