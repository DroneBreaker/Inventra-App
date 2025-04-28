import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inventra/constants/app_colors.dart';
import 'package:inventra/constants/app_titles.dart';
import 'package:inventra/screens/auth/login.dart';
import 'package:inventra/services/api_service.dart';
import 'package:inventra/widgets/app_text.dart';
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

  Future<void> handleRegister() async {
    // Validate inputs
    if(passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: AppText(title: "Passwords do not match!"),
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
        password: passwordController.text,
      );

      final responseData = jsonDecode(response.body);

      if(response.statusCode == 200 || response.statusCode == 201) {
        // Registration successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText(title: responseData['message'] ?? 'Registration succcessful'),
            backgroundColor: AppColors.success,
          ),
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
          SnackBar(content: AppText(title: responseData['error'] ?? "Registration failed"),
          backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(title: "Error: ${e.toString()}"),
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
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AppColors.success,
              AppColors.white
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 20, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(child: AppText(title: AppTitle.registerTitle, fontSize: 30,),),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      contentPadding: const EdgeInsets.only(left: 20),
                      labelText: "First Name",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18)
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
                  //  Last Name TextForm field
                  TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      contentPadding: const EdgeInsets.only(left: 20),
                      labelText: "Last Name",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18)
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
                  // Email TextForm field
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      contentPadding: const EdgeInsets.only(left: 20),
                      labelText: "Email",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18)
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
                  // Username TextForm field
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      contentPadding: const EdgeInsets.only(left: 20),
                      labelText: "Username",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18)
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
                  // Company Name TextForm field
                  TextFormField(
                    controller: companyNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      contentPadding: const EdgeInsets.only(left: 20),
                      labelText: "Company Name",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18)
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return AppTitle.companyNameError;
                      }
                    },
                  ),
                  
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: companyIDController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      contentPadding: const EdgeInsets.only(left: 20),
                      labelText: "Company ID",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18)
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return AppTitle.companyIDError;
                      }
                      if(value.length < 6) {
                        return AppTitle.validCompanyIDError;
                      }
                    },
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
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18)
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return AppTitle.companyTINError;
                      }
                      if(value.length < 6) {
                        return AppTitle.validCompanyTINError;
                      }
                    },
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
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18)
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
                  TextFormField(
                    obscureText: true,
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      contentPadding: const EdgeInsets.only(left: 20),
                      labelText: "Confirm Password",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18)
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
                  Row(
                    children: [
                      AppText(title: AppTitle.hasAccount, fontSize: 18,),
                      Button(buttonText: AppTitle.loginButton, fontSize: 18, onTap: () {
                        Navigator.pushReplacement(
                          context, 
                          MaterialPageRoute(builder: (context) => LoginPage())
                        );
                      })
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black54,
                          foregroundColor: Colors.white
                      ),
                      onPressed: () {
                        handleRegister();
                      },
                      child: AppText(title: AppTitle.registerButton, colors: Colors.black, fontSize: 20,),
                    ),
                  )
                ],
              ),
            ),
          )
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
