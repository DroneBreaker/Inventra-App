import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inventra/constants/app_colors.dart';
import 'package:inventra/constants/app_titles.dart';
import 'package:inventra/screens/taxpayer.dart';
import 'package:inventra/services/api_service.dart';
import 'package:inventra/widgets/app_text.dart';
import 'package:inventra/widgets/button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String selected = 'Select User Type';
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  // Controllers for different form fields
  final TextEditingController businessPartnerTINController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final List<String> dropdownOptions = [
    'Select User Type',
    'Taxpayer',
    'Authority',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 28, 151, 196),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromRGBO(163, 201, 226, 1.5),
              Color.fromRGBO(150, 24, 247, 0.5),
              Color.fromRGBO(246, 239, 167, 0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 110.0, left: 20, right: 20),
              child: Column(
                children: [
                  const SizedBox(height: 38),
                  const AppText(
                    title: AppTitle.loginTitle,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 10),
                  const AppText(
                    title: AppTitle.loginDescription,
                    fontSize: 18,
                  ),
                  const SizedBox(height: 25),

                  // Dropdown field
                  DropdownButtonFormField<String>(
                    value: selected,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'User Type',
                    ),
                    items: dropdownOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selected = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildDynamicFields(),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black54,
                          foregroundColor: Colors.white),
                      onPressed: () {
                        // if (_formKey.currentState!.validate()) {
                        //   // Handle form submission
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(
                        //       content: Text('Login been processed...'),
                        //     ),
                        //   );
                        //   // Add your login logic here
                        //   if (_formKey.currentState!.validate()) {
                        //     _handleLogin();
                        //   }
                        // }

                        handleLogin();
                      },
                      child: const Text(
                        AppTitle.logInButton,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicFields() {
    switch (selected) {
      case 'Select User Type':
        return const SizedBox();
      case 'Taxpayer':
        return Form(
          key: _formKey,
          child: Column(
            children: [
              // business TIN for TP
              TextFormField(
                controller: businessPartnerTINController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  labelText: 'Business TIN',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your TIN';
                  }
                  if (value.length < 6 && value.length <= 11) {
                    return 'Business TIN must be between 6 and 11 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Username section for TP
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  if (value.length < 6) {
                    return 'Username must be 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Password section for TP
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      icon: Icon(_isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off)),
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        );

      case 'Authority':
        return Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  if (value == value && value.length < 6) {
                    return 'Username must be 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Passwowrd section for Authority
              TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value == value) {
                    return 'Please enter a valid password';
                  }
                  return null;
                },
              ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    businessPartnerTINController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showPasswordToggle() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  // Login functionality
  Future<void> handleLogin() async {
    // Validate form
    if(!_formKey.currentState!.validate()) {
      return;
    }

    // Validate user type selection
    if(selected == "Select User Type") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(title: "Please select a user type"),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator(),);
      }
    );

    try {
      final response = await APIService.loginUser(
        userType: selected, 
        username: usernameController.text, 
        password: passwordController.text,
        businessPartnerTIN: selected == "Taxpayer" ? businessPartnerTINController.text : null,
      );

      // Hide loading indicator
      Navigator.pop(context);

      final responseData = jsonDecode(response.body);

      if(response.statusCode == 200) {
        // Login successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText(title: responseData['message'] ?? 'Login successful!'),
            backgroundColor: AppColors.success,
          ),
        );

        // Navigate based on user type
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const TaxpayerPage()),
        );
      } else {
        // Login failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText(title: responseData['error'] ?? 'Login failed'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      // Hide loading indicator
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
