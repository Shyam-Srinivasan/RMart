import 'package:flutter/material.dart';
import 'package:rmart/home_page.dart';
import 'package:rmart/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
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
                height: height/2.7,
                child: Image.asset("assets/img/Login.json"),
              ),
              TextFieldInput(
                  textEditingController: nameController,
                  hintText: "Enter your Name",
                  icon: Icons.person),
              TextFieldInput(
                textEditingController: emailController,
                hintText: "Enter you college mail",
                icon: Icons.email,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Resend OTP",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,color: Colors.blue)
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Homepage()));
                },
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: ShapeDecoration(shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                      color: Colors.blue,
                    ),
                    child: const Text(
                      "Log In",
                      style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),),
                  ),
                ),
              ),
              SizedBox(height: height/15),
              /* Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Resend OTP"),
                  GestureDetector(onTap: (){},
                  child: Text,)
                ],
              ) */
            ],
          ),
        ),
      ),
    );
  }
}
