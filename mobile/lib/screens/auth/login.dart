import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inventra/constants/app_colors.dart';
import 'package:inventra/constants/app_titles.dart';
import 'package:inventra/screens/auth/register.dart';
import 'package:inventra/screens/home.dart';
import 'package:inventra/wrappers/main_wrapper.dart';
import 'package:inventra/services/api_service.dart';
import 'package:inventra/widgets/app_text.dart';
import 'package:inventra/widgets/button.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:inventra/widgets/button.dart';





class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController companyTINController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
          decoration: BoxDecoration(
            color: Colors.white70
          ),
          child: Padding(
              padding: const EdgeInsets.only(top: 200.0, left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(child: AppText(title: AppTitle.loginTitle, fontSize: 30,),),
                    const SizedBox(height: 20,),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        contentPadding: const EdgeInsets.only(left: 20),
                        labelText: "Username",
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 18)
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return AppTitle.noUsernameError;
                        }
                        if(value.length < 6) {
                          return AppTitle.usernameLengthError;
                        }
                      }
                    ),
                    const SizedBox(height: 20,),
                    TextFormField(
                      controller: companyTINController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        contentPadding: const EdgeInsets.only(left: 20),
                        labelText: "Company TIN",
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 18)
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return AppTitle.companyTINError;
                        }
                        if(value.length < 6) {
                          return AppTitle.validCompanyTINError;
                        }
                      }
                    ),
                    const SizedBox(height: 20,),
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        contentPadding: const EdgeInsets.only(left: 20),
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 18)
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return AppTitle.noPasswordError;
                        }
                        if(value.length < 6) {
                          return AppTitle.passwordLengthError;
                        }
                      },
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(title: AppTitle.noAccount, fontSize: 18, colors: Colors.grey,),
                        Button(buttonText: AppTitle.createAccount, fontSize: 18, onTap: () {
                          Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(builder: (context) => RegisterPage())
                          );
                        })
                      ],
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white
                        ),
                        onPressed: () {
                          handleLogin();
                        },
                        child: AppText(title: AppTitle.loginButton, colors: Colors.black, fontSize: 20,),
                      ),
                    )
                  ],
                ),
              ),
            ),
        )
        ),
    );
  }


  Future<void> handleLogin() async {
    if(!_formKey.currentState!.validate()) {
      return;
    }

    // Show loading indicator
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      }
    );

    try {
      final response = await APIService.loginUser(
        username: usernameController.text, 
        companyTIN: companyTINController.text,
        password: passwordController.text,
      );

      
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      final responseData = jsonDecode(response.body);

      if(response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("userData", jsonEncode(responseData['user']));
        print("Navigation executing");

        // Navigate to home
        if(!mounted) return;
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) {
            print("Building MainWrapper -> to PAGE");
            return const MainWrapper();
          }),
          (route) => false
        );
      } else {
        if(!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['error'] ?? 'Login failed'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
