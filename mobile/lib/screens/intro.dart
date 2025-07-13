import 'package:flutter/material.dart';
import 'package:inventra/screens/auth/register.dart';
import 'package:inventra/screens/auth/login.dart';
import 'package:inventra/widgets/titles.dart';
import 'package:inventra/widgets/button.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          // backgroundColor: AppColors.grey600,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 380.0),
              child: Column(
                children: [
                  Center(child: appTitle(title: "INVENTRA", color: Colors.grey,),),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, top: 235, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        appButton(buttonText: "Sign In", colors: Colors.grey, onTap: () {
                          Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(builder: (context) => const LoginPage())
                          );
                        }),
                        appButton(buttonText: "Sign Up", colors: Colors.grey, onTap: () {
                          Navigator.pushReplacement(
                          context, 
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
                        );
                        }),
                      ],
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