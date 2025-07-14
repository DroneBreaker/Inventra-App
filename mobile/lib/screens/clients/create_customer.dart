import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:inventra/config/app_colors.dart';
import 'package:inventra/config/app_text.dart';
import 'package:inventra/services/customer_service.dart';
import 'package:inventra/widgets/forms.dart';
import 'package:inventra/widgets/titles.dart';

class CreateCustomerPage extends StatefulWidget {
  const CreateCustomerPage({super.key});

  @override
  State<CreateCustomerPage> createState() => _CreateCustomerPage();
}

class _CreateCustomerPage extends State<CreateCustomerPage> {
  final TextEditingController customerNameTextController = TextEditingController();
  final TextEditingController customerTINTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController phoneTextController = TextEditingController();

  // CLIENT TYPE
  final clientType = [
    "Customer",
    "Supplier",
    "Export"
  ];
  String selectedClientType = "Customer";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        // child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 150.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      appTitle(title: "CUSTOMER FUCKERS"),
                      Gap(20.h),
            

                      // Customer Name TextForm field
                      appInput(placeholder: "Customer Name", textEditingController: customerNameTextController),
                      Gap(20.h),


                      // Customer TIN TextForm field
                      appInput(placeholder: "Customer TIN", textEditingController: customerTINTextController),
                      Gap(20.h),


                      // Customer Email TextForm field
                      appInput(placeholder: "Email", textEditingController: emailTextController, textInputType: TextInputType.emailAddress),
                      Gap(20.h),


                      // Client Type
                      appDropdown(selectedValue: selectedClientType, items: clientType,),
                      Gap(20.h),


                      // Customer Phone TextForm field
                      appInput(placeholder: "Phone Number", textEditingController: phoneTextController, textInputType: TextInputType.phone),
                      Gap(20.h),


                      // Button
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange
                          ),
                          onPressed: () {
                            addCustomers();
                          }, 
                          child: appTitle(title: AppText.addClientButton, color: AppColors.white)
                        )
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        // )
      ),
    );
  }

  // Function to add customers
  Future<void> addCustomers() async {
    if(_formKey.currentState!.validate()) {
      try {
        // Create the customer object
        final response = await CustomerService.addCustomer(
          clientName: customerNameTextController.text,
          clientTIN: customerTINTextController.text,
          clientEmail: emailTextController.text,
          clientType: selectedClientType ?? "Customer",
          clientPhone: phoneTextController.text,
        );

        // Hide loading indicator
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (response['success'] == true) {
          // Show success message
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(response['message'])),
          // );

          
          // Clear the form
          _formKey.currentState!.reset();
          setState(() {
            selectedClientType = "Customer";
          });

          // Try to get customer data from response
          final customerData = response['data'] ?? response['customer'];
          
          if (customerData != null) {
            print('About to show modal with data: $customerData');
          } else {
            print('No customer data found in response');
            // Fallback to SnackBar if no customer data
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response['message'] ?? 'Customer created successfully')),
            );
          }
            
        } else {
          // Error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: appParagraph(title: 'Error: $e')),
          );
        }
      }
    }
    // print("Customer added");
  }
}