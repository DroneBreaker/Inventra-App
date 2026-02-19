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
  final TextEditingController customerNameTextController =
      TextEditingController();
  final TextEditingController customerTINTextController =
      TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController phoneTextController = TextEditingController();

  // CLIENT TYPE
  final clientType = ["Customer", "Supplier", "Export"];
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
            height:
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    appTitle(title: "CUSTOMER FUCKERS"),
                    Gap(20.h),

                    // Customer Name TextForm field
                    appInput(
                      placeholder: "Customer Name",
                      textEditingController: customerNameTextController,
                    ),
                    Gap(20.h),

                    // Customer TIN TextForm field
                    appInput(
                      placeholder: "Customer TIN",
                      textEditingController: customerTINTextController,
                    ),
                    Gap(20.h),

                    // Customer Email TextForm field
                    appInput(
                      placeholder: "Email",
                      textEditingController: emailTextController,
                      textInputType: TextInputType.emailAddress,
                    ),
                    Gap(20.h),

                    // Client Type
                    appDropdown(
                      selectedValue: selectedClientType,
                      items: clientType,
                      onChanged: (value) {
                        setState(() {
                          selectedClientType = value!;
                        });
                      },
                    ),
                    Gap(20.h),

                    // Customer Phone TextForm field
                    appInput(
                      placeholder: "Phone Number",
                      textEditingController: phoneTextController,
                      textInputType: TextInputType.phone,
                    ),
                    Gap(20.h),

                    // Button
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        onPressed: () {
                          addCustomers();
                        },
                        child: appTitle(
                          title: AppText.addClientButton,
                          color: AppColors.white,
                        ),
                      ),
                    ),
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
  // Function to add customers
  Future<void> addCustomers() async {
    if (_formKey.currentState!.validate()) {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adding customer...'),
          duration: Duration(seconds: 3),
        ),
      );

      try {
        // Create the customer object
        final response = await CustomerService.addCustomer(
          clientName: customerNameTextController.text,
          clientTIN: customerTINTextController.text,
          clientEmail: emailTextController.text,
          clientType: selectedClientType,
          clientPhone: phoneTextController.text,
        );

        // Hide loading indicator
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // Check if response contains success message
        if (response['message'] != null && response['client'] != null) {
          // Clear the form
          _formKey.currentState!.reset();
          customerNameTextController.clear();
          customerTINTextController.clear();
          emailTextController.clear();
          phoneTextController.clear();

          setState(() {
            selectedClientType = "Customer";
          });

          // Get customer data from response
          final clientData = response['client'];

          print('Customer added successfully: $clientData');

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response['message'] ?? 'Customer created successfully',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );

          // TODO: If you want to show a modal with customer details, add it here
          // showDialog(
          //   context: context,
          //   builder: (context) => CustomerDetailsModal(customer: clientData),
          // );
        } else {
          // Error case - response doesn't have expected success structure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                response['error'] ??
                    response['message'] ??
                    'Failed to add customer',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } catch (e) {
        // Hide loading indicator if still showing
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }
}
