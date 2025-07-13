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
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;

  // Role options
  String selectedRoles = "Staff";
  final roleOptions = [
    "Staff",
    "Admin"
  ];

  Future<void> handleRegister() async {
    // Validate inputs
    if(passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match!"),
          backgroundColor: AppColors.error,
        )
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

      if(response.statusCode == 200 || response.statusCode == 201) {
        // Registration successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: appTitle(title: responseData['message'] ?? 'Registration succcessful'),
            backgroundColor: AppColors.success,
          ),
        );

        // Navigate to login
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const LoginPage())
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
          SnackBar(content: appTitle(title: responseData['error'] ?? "Registration failed"),
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
      if(mounted) {
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
              gradient: LinearGradient(colors: [
                AppColors.accent,
                AppColors.grey500
              ])
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
                        topRight: Radius.circular(30.r)
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
                      padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                      child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Center(child: appTitle(title: AppText.registerTitle, color: Colors.black),),
                              Gap(20.h),
                                   
                              
                              // First Name TextForm field
                              appInput(placeholder: "First Name", textEditingController: firstNameController, 
                                errorMsg: AppText.noUsernameError, errorLengthMsg: AppText.usernameLengthError
                              ),
                              Gap(20.h),
                                      
                                      
                              //  Last Name TextForm field
                              appInput(placeholder: "Last Name", textEditingController: lastNameController, 
                                errorMsg: AppText.noUsernameError, errorLengthMsg: AppText.usernameLengthError),
                              Gap(20.h),
                                      
                                      
                              // Email TextForm field
                              appInput(placeholder: "Email", textEditingController: emailController, textInputType: TextInputType.emailAddress,
                                errorMsg: AppText.noPasswordError, errorLengthMsg: AppText.passwordLengthError
                              ),
                              Gap(20.h),
                                      
                                      
                              // Username TextForm field
                              appInput(placeholder: "Usename", textEditingController: usernameController, 
                                errorMsg: AppText.noUsernameError, errorLengthMsg: AppText.usernameLengthError
                              ),
                              Gap(20.h),
                                      
                                      
                              // Company Name TextForm field
                              appInput(placeholder: "Company Name", textEditingController: companyNameController, 
                                errorMsg: AppText.companyNameError, errorLengthMsg: AppText.companyNameError
                              ),
                              Gap(20.h),


                              // Company ID TextForm field
                              appInput(placeholder: "Company ID", textEditingController: companyNameController, 
                                errorMsg: AppText.companyIDError, errorLengthMsg: AppText.validCompanyIDError
                              ),
                              const SizedBox(height: 20,),
                                      
                                      
                              // Company TIN Textform field
                              appInput(placeholder: "Company TIN", textEditingController: companyNameController, 
                                errorMsg: AppText.companyTINError, errorLengthMsg: AppText.validCompanyTINError
                              ),
                              Gap(20.h),
                                      
                                      
                              // Role
                              DropdownButtonFormField<String>(
                                value: selectedRoles,
                                items: roleOptions
                                    .map((role) => DropdownMenuItem(
                                          value: role,
                                          child: Text(role),
                                        ))
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
                              SizedBox(height: 20,),
                                      
                                      
                              // Password Textform field
                              TextFormField(
                                obscureText: true,
                                controller: passwordController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  contentPadding: const EdgeInsets.only(left: 20),
                                  labelText: "Password",
                                ),
                                validator: (value) {
                                  if(value == null || value.isEmpty) {
                                    return AppText.noPasswordError;
                                  }
                                  if(value.length < 6) {
                                    return AppText.passwordLengthError;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20,),
                                      
                                      
                              // 
                              TextFormField(
                                obscureText: true,
                                controller: confirmPasswordController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  contentPadding: const EdgeInsets.only(left: 20),
                                  labelText: "Confirm Password",
                                ),
                                validator: (value) {
                                  if(value == null || value.isEmpty) {
                                    return AppText.noPasswordError;
                                  }
                                  if(value.length < 6) {
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
                                      foregroundColor: Colors.white
                                  ),
                                  onPressed: () {
                                    handleRegister();
                                  },
                                  child: appTitle(title: AppText.registerButton, color: AppColors.white),
                                ),
                              ),
                              Gap(10.h),


                              // 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  appParagraph(title: AppText.hasAccount, fontSize: 18, color: Colors.grey,),
                                  appButton(buttonText: AppText.loginButton, colors: Colors.black, onTap: () {
                                    Navigator.pushReplacement(
                                      context, 
                                      MaterialPageRoute(builder: (context) => LoginPage())
                                    );
                                  })
                                ],
                              ),
                              Gap(70.h)


                            ],
                          ),
                        ),
                      ),
                    )
                                    ),
              ]
                        ),
            ),
    );
  }
}
// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController companyTINController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();

//   String selected = "Select User Type";
//   final List<String> dropdownOptions = [
//     'Select User Type',
//     'Taxpayer',
//     'Authority',
//   ];

//   bool isLoading = false;

//   Future<void> handleRegister() async {
//     // Validate inputs
//     if(passwordController.text != confirmPasswordController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: AppText(title: "Passwords do not match!"),
//           backgroundColor: AppColors.error,
//         )
//       );
//       return;
//     }

//     if(selected == "Select User Type") {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: AppText(title: "Please select a user type!"),
//           backgroundColor: AppColors.error,
//         )
//       );
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final response = await APIService.registerUser(
//         firstName: firstNameController.text, 
//         lastName: lastNameController.text,
//         companyTIN: companyTINController.text, 
//         // email: emailController.text, 
//         username: usernameController.text, 
//         password: passwordController.text,
//       );

//       final responseData = jsonDecode(response.body);

//       if(response.statusCode == 200 || response.statusCode == 201) {
//         // Registration successful
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: AppText(title: responseData['message'] ?? 'Registration succcessful'),
//             backgroundColor: AppColors.success,
//           ),
//         );

//         // Navigate based on user type
//         if(selected == "Taxpayer") {
//           Navigator.pushReplacement(
//             context, 
//             MaterialPageRoute(builder: (context) => const TaxpayerPage()),
//           );
//         } else {
//           Navigator.pop(context);
//         }
//       } else {
//         // Registration failed
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: AppText(title: responseData['error'] ?? "Registration failed"),
//           backgroundColor: AppColors.error,
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: AppText(title: "Error: ${e.toString()}"),
//           backgroundColor: AppColors.error,
//         ),
//       );
//     } finally {
//       if(mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: const Color.fromARGB(255, 28, 151, 196),
//         body: Container(
//           height: MediaQuery.of(context).size.height,
//           decoration: const BoxDecoration(
//               gradient: LinearGradient(
//             colors: [
//               AppColors.accentDark,
//               AppColors.background,
//               // Color.fromRGBO(163, 201, 226, 1.5),
//               // Color.fromRGBO(150, 24, 247, 0.5),
//               // Color.fromRGBO(246, 239, 167, 0.5),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           )),
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.only(top: 60, left: 20.0, right: 20),
//               child: Form(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 24),
//                     const AppText(
//                       title: "Droners Invoicify",
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       colors: Colors.white,
//                     ),
//                     const AppText(
//                       title: "Please register your account",
//                       fontSize: 17,
//                       colors: Colors.white,
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     // Dropdown field
//                   DropdownButtonFormField<String>(
//                     value: selected,
//                     decoration: InputDecoration(
//                       enabledBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.white)),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                       labelText: 'User Type',
//                     ),
//                     items: dropdownOptions.map((String option) {
//                       return DropdownMenuItem<String>(
//                         value: option,
//                         child: Text(option),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selected = newValue!;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 20,),

//                   _buildDynamicFields(), 
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }


//   Widget _buildDynamicFields() {
//     switch (selected) {
//       case 'Select User Type':
//         return const SizedBox();
//       case 'Taxpayer':
//         return Form(
//           key: _formKey,
//           child: Column(
//           children: [
//             // First Name Text field
//             TextFormField(
//               controller: firstNameController,
//               // onChanged: (value) => setState(() => firstNameController = value),
//               decoration: InputDecoration(
//                   enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white)),
//                   // labelStyle: const TextStyle(color: Colors.white),
//                   labelText: 'First Name',
//                   labelStyle: TextStyle(color: Colors.black),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10))),
//             ),
//             const SizedBox(height: 20,),
//             // Last Name Textfield
//             TextFormField(
//               controller: lastNameController,
//               // onChanged: (value) => setState(() => firstNameController = value),
//               decoration: InputDecoration(
//                   enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white)),
//                   labelText: 'Last Name',
//                   labelStyle: TextStyle(color: Colors.black),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10))),
//             ),
//             const SizedBox(height: 20),
//             //Business Partner TIN Textform field
//             TextFormField(
//               controller: companyTINController,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your TIN';
//                 }
//                 if (value.length < 6 && value.length <= 11) {
//                   return 'Business TIN must be between 6 and 11 characters long';
//                 }
//                 return null;
//               },
//               // onChanged: (value) => setState(() => firstNameController = value),
//               decoration: InputDecoration(
//                   enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white)),
//                   labelText: 'Business TIN',
//                   labelStyle: const TextStyle(color: Colors.black),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10))),
//             ),
//             const SizedBox(height: 20,),
//             // Email Textform field
//             TextFormField(
//               controller: emailController,
//               // onChanged: (value) => setState(() => firstNameController = value),
//               decoration: InputDecoration(
//                   enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white)),
//                   labelText: 'Email',
//                   labelStyle: const TextStyle(color: Colors.black),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10))),
//             ),
//             const SizedBox(height: 20,),
//             // Username Textform field
//             TextFormField(
//               controller: usernameController,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your username';
//                 }
//                 if (value.length < 6) {
//                   return 'Username must be 6 characters long';
//                 }
//                 return null;
//               },
//               // onChanged: (value) => setState(() => firstNameController = value),
//               decoration: InputDecoration(
//                   enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white)),
//                   labelText: 'Username',
//                   labelStyle: const TextStyle(color: Colors.black),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10))),
//             ),
//             const SizedBox(height: 20,),
//             // Password Textform field
//             TextFormField(
//               obscureText: true,
//               controller: passwordController,
//               // onChanged: (value) => setState(() => firstNameController = value),
//               decoration: InputDecoration(
//                   enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white)),
//                   labelText: 'Password',
//                   labelStyle: const TextStyle(color: Colors.black),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10))),
//             ),
//             const SizedBox(height: 20,),
//             // Confirm Password Textform field
//             TextFormField(
//               obscureText: true,
//               controller: confirmPasswordController,
//               // onChanged: (value) => setState(() => firstNameController = value),
//               decoration: InputDecoration(
//                   enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white)),
//                   labelText: 'Confirm Password',
//                   labelStyle: const TextStyle(color: Colors.black),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10))),
//             ),
//             const SizedBox(height: 20,),
//             Button(
//               buttonText: "Register",
//               // size: const Size(160, 55),
//               colors: AppColors.buttonPrimary,
//               fontSize: 20,
//               onTap: () => {
//                 // TODO: Implement registration logic here
//                 handleRegister()
//               },
//               // setState(() {});
//             ),
//           ],
//         ));

//       case 'Authority':
//         return Form(
//           child: Column(
//             children: [
//               // Authority First Name Textform field
//               TextFormField(
//               controller: firstNameController,
//               // onChanged: (value) => setState(() => firstNameController = value),
//               decoration: InputDecoration(
//                   enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white)),
//                   labelText: 'First Name',
//                   labelStyle: const TextStyle(color: Colors.black),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10))),
//             ),
//             const SizedBox(height: 20,),
//             // Authority Last NAme Textform field
//             TextFormField(
//               controller: lastNameController,
//               // onChanged: (value) => setState(() => firstNameController = value),
//               decoration: InputDecoration(
//                   enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white)),
//                   labelText: 'Last Name',
//                   labelStyle: const TextStyle(color: Colors.black),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10))),
//             ),
//             const SizedBox(height: 20,),
//             // Authority Username Textform field
//             TextFormField(
//               controller: usernameController,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your username';
//                 }
//                 if (value.length < 6) {
//                   return 'Username must be 6 characters long';
//                 }
//                 return null;
//               },
//               // onChanged: (value) => setState(() => firstNameController = value),
//               decoration: InputDecoration(
//                   enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white)),
//                   labelText: 'Username',
//                   labelStyle: const TextStyle(color: Colors.black),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10))),
//             ),
//             const SizedBox(height: 20,),
//             // Authority Email Textform field
//             TextFormField(
//               controller: emailController,
//               // onChanged: (value) => setState(() => firstNameController = value),
//               decoration: InputDecoration(
//                   enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white)),
//                   labelText: 'Email',
//                   labelStyle: const TextStyle(color: Colors.black),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10))),
//             ),
//             const SizedBox(height: 20,),
//             // Authority Password Textform field
//             TextFormField(
//               obscureText: true,
//               controller: passwordController,
//               // onChanged: (value) => setState(() => firstNameController = value),
//               decoration: InputDecoration(
//                   enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white)),
//                   labelText: 'Password',
//                   labelStyle: const TextStyle(color: Colors.black),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10))),
//             ),
//             const SizedBox(height: 20,),
//             // Authority Confirm Password Textform field
//             TextFormField(
//               obscureText: true,
//               controller: confirmPasswordController,
//               // onChanged: (value) => setState(() => firstNameController = value),
//               decoration: InputDecoration(
//                   enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white)),
//                   labelText: 'Confirm Password',
//                   labelStyle: const TextStyle(color: Colors.black),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10))),
//             ),
//             const SizedBox(height: 20,),
//             // Authority Button
//             Button(
//               buttonText: "Register",
//               // size: const Size(160, 55),
//               colors: AppColors.buttonPrimary,
//               fontSize: 20,
//               onTap: () => {
//                 // TODO: Implement registration logic here
//                 handleRegister()
//               },
//               // setState(() {});
//             ),
//         ],),);

//       default:
//         return const SizedBox.shrink();
//     }
//   }

//   @override
//   void dispose() {
//     companyTINController.dispose();
//     usernameController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   // void handleRegister() {
//   //   Future.delayed(const Duration(seconds: 2), () {
//   //     Navigator.pop(context); // Remove loading indicator

//   //     // Here you would typically make your actual API call
//   //     // For now, we'll just show a success message
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(
//   //         content: Text('Login Successful!'),
//   //         backgroundColor: Colors.green,
//   //       ),
//   //     );

//   //     // Add your navigation logic here
//   //     Navigator.pushReplacement(
//   //       context,
//   //       MaterialPageRoute(builder: (context) => const TaxpayerPage()),
//   //     );
//   //   });
//   // }
// }
