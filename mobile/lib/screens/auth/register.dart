import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:inventra/config/app_colors.dart';
import 'package:inventra/config/app_text.dart';
import 'package:inventra/screens/auth/login.dart';
import 'package:inventra/services/api_service.dart';
import 'package:inventra/widgets/forms.dart';
import 'package:inventra/widgets/titles.dart';
import 'package:inventra/widgets/button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController companyIDController = TextEditingController();
  final TextEditingController companyTINController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  // Role options
  String selectedRoles = "Staff";
  final roleOptions = ["Staff", "Admin"];

  Future<void> handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate inputs
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match!"),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // if(selected == "Select User Type") {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: AppText(title: "Please select a user type!"),
    //       backgroundColor: AppColors.error,
    //     )
    //   );
    //   return;
    // }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await APIService.registerUser(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        username: usernameController.text,
        companyName: companyNameController.text,
        companyID: companyIDController.text,
        companyTIN: companyTINController.text,
        role: selectedRoles,
        password: passwordController.text,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registration successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: appTitle(
              title: responseData['message'] ?? 'Registration succcessful',
            ),
            backgroundColor: AppColors.success,
          ),
        );

        // Navigate to login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );

        // // Navigate based on user type
        // if(selected == "Taxpayer") {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => const TaxpayerPage()),
        //   );
        // } else {
        //   Navigator.pop(context);
        // }
      } else {
        // Registration failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: appTitle(
              title: responseData['error'] ?? "Registration failed",
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: appTitle(title: "Error: ${e.toString()}"),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      extendBodyBehindAppBar: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.accent, AppColors.grey500],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                height: 640.h,
                width: 412.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                  //   gradient: LinearGradient(colors: [
                  //     AppColors.success,
                  //     AppColors.white
                  //   ],
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  // )
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 20,
                    right: 20,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Center(
                            child: appTitle(
                              title: AppText.registerTitle,
                              color: Colors.black,
                            ),
                          ),
                          Gap(20.h),

                          // First Name TextForm field
                          appInput(
                            placeholder: "First Name",
                            textEditingController: firstNameController,
                            errorMsg: AppText.noUsernameError,
                            errorLengthMsg: AppText.usernameLengthError,
                          ),
                          Gap(20.h),

                          //  Last Name TextForm field
                          appInput(
                            placeholder: "Last Name",
                            textEditingController: lastNameController,
                            errorMsg: AppText.noUsernameError,
                            errorLengthMsg: AppText.usernameLengthError,
                          ),
                          Gap(20.h),

                          // Email TextForm field
                          appInput(
                            placeholder: "Email",
                            textEditingController: emailController,
                            textInputType: TextInputType.emailAddress,
                            errorMsg: AppText.noPasswordError,
                            errorLengthMsg: AppText.passwordLengthError,
                          ),
                          Gap(20.h),

                          // Username TextForm field
                          appInput(
                            placeholder: "Usename",
                            textEditingController: usernameController,
                            errorMsg: AppText.noUsernameError,
                            errorLengthMsg: AppText.usernameLengthError,
                          ),
                          Gap(20.h),

                          // Company Name TextForm field
                          appInput(
                            placeholder: "Company Name",
                            textEditingController: companyNameController,
                            errorMsg: AppText.companyNameError,
                            errorLengthMsg: AppText.companyNameError,
                          ),
                          Gap(20.h),

                          // Company ID TextForm field
                          appInput(
                            placeholder: "Company ID",
                            textEditingController: companyIDController,
                            errorMsg: AppText.companyIDError,
                            errorLengthMsg: AppText.validCompanyIDError,
                          ),
                          const SizedBox(height: 20),

                          // Company TIN Textform field
                          appInput(
                            placeholder: "Company TIN",
                            textEditingController: companyTINController,
                            errorMsg: AppText.companyTINError,
                            errorLengthMsg: AppText.validCompanyTINError,
                          ),
                          Gap(20.h),

                          // Role
                          DropdownButtonFormField<String>(
                            value: selectedRoles,
                            items:
                                roleOptions
                                    .map(
                                      (role) => DropdownMenuItem(
                                        value: role,
                                        child: Text(role),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedRoles = value!;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Role',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),

                          // Password Textform field
                          TextFormField(
                            obscureText: true,
                            controller: passwordController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.only(left: 20),
                              labelText: "Password",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppText.noPasswordError;
                              }
                              if (value.length < 6) {
                                return AppText.passwordLengthError;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          //
                          TextFormField(
                            obscureText: true,
                            controller: confirmPasswordController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.only(left: 20),
                              labelText: "Confirm Password",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppText.noPasswordError;
                              }
                              if (value.length < 6) {
                                return AppText.passwordLengthError;
                              }
                              return null;
                            },
                          ),
                          Gap(20.h),

                          // Button
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                handleRegister();
                              },
                              child: appTitle(
                                title: AppText.registerButton,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          Gap(10.h),

                          //
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              appParagraph(
                                title: AppText.hasAccount,
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                              appButton(
                                buttonText: AppText.loginButton,
                                colors: Colors.black,
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Gap(70.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    companyNameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    companyIDController.dispose();
    companyTINController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
