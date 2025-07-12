import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventra/config/app_colors.dart';
import 'package:inventra/config/app_titles.dart';
import 'package:inventra/screens/auth/register.dart';
import 'package:inventra/wrappers/main_wrapper.dart';
import 'package:inventra/services/api_service.dart';
import 'package:inventra/widgets/app_text.dart';
import 'package:inventra/widgets/button.dart';
import 'package:shared_preferences/shared_preferences.dart';



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
    return Scaffold(
        appBar: null,
        extendBodyBehindAppBar: true,
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                AppColors.accent,
                AppColors.grey500
              ],
              )
            ),
            child: Stack(
              children: [ 
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 640.h,
                    width: 412.w,
                  // height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r)
                    ),
                  ),
                  child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Center(child: appText(title: AppTitle.loginTitle, fontSize: 30,),),
                              const SizedBox(height: 20,),
                                
                                
                              // Username TextForm field
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
                                  return null;
                                }
                              ),
                              const SizedBox(height: 20,),
                                
                                
                              // Company TIN TextForm field
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
                                  return null;
                                }
                              ),
                              const SizedBox(height: 20,),
                                
                                
                              // Password TextForm field
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
                                  return null;
                                },
                              ),
                              // const SizedBox(height: 10,),
                                
                                
                              // 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  appText(title: AppTitle.noAccount, fontSize: 18, color: Colors.grey,),
                                
                                  Button(buttonText: AppTitle.createAccount, colors: Colors.grey, fontSize: 18, onTap: () {
                                      Navigator.pushReplacement(
                                        context, 
                                        MaterialPageRoute(builder: (context) => RegisterPage())
                                      );
                                    }),
                                ],
                              ),
                              // const SizedBox(height: 20,),
                                
                                
                              // Button
                              SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: ElevatedButton(
                                  onPressed: () {
                                    handleLogin();
                                  }, 
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey
                                  ),
                                  child: appText(title: AppTitle.loginButton, color: Colors.white, fontSize: 18,),)
                              )
                            ],
                          ),
                        ),
                      ),
                  ),
                ),
              ]
            ),
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
      
        // Store all user data
        await prefs.setString("userData", jsonEncode(responseData['user']));
        
        // Explicitly store the token
        await prefs.setString("jwt_token", responseData['token']);
        
        // Explicitly store company TIN for easy access
        await prefs.setString("company_tin", companyTINController.text);
        print("Navigation executing");

        // Navigate to home
        if(!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) {
            print("Building MainWrapper -> to PAGE");
            return const MainWrapper();
          }),
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
