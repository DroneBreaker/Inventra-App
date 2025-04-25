import 'package:flutter/material.dart';
import 'package:inventra/constants/app_colors.dart';
import 'package:inventra/screens/auth/register.dart';
import 'package:inventra/screens/auth/login.dart';
import 'package:inventra/widgets/app_text.dart';
import 'package:inventra/widgets/button.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.grey600,
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AppColors.shadow,
              AppColors.white
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 420.0),
            child: Column(
              children: [
                Center(child: AppText(title: "INVENTRA", fontSize: 45,),),
                Padding(
                  padding: const EdgeInsets.only(left: 100.0, top: 280),
                  child: Row(
                    children: [
                      Button(buttonText: "Sign In", fontSize: 20, onTap: () {
                        Navigator.pushReplacement(
                          context, 
                          MaterialPageRoute(builder: (context) => const LoginPage())
                        );
                      }),
                      Button(buttonText: "Sign Up", fontSize: 20, onTap: () {
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