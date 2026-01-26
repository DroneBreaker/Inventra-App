import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventra/config/app_text.dart';
import 'package:inventra/config/routes.dart';
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
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: null,
      body: SafeArea(
        // backgroundColor: AppColors.grey600,
        child: Container(
          height: double.infinity,
          // decoration: BoxDecoration(color: Colors.black),
          child: Padding(
            padding: const EdgeInsets.only(top: 320.0),
            child: Column(
              children: [
                Center(
                  child: appTitle(
                    title: AppText.companyName,
                    color: Colors.grey,
                    fontSize: 40.sp,
                    letterSpacing: 14,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30.0,
                    top: 315,
                    right: 30,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      appButton2(AppText.signIn, () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      }, letterSpacing: 1),
                      appButton2(AppText.signUp, () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      }, letterSpacing: 1),
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
