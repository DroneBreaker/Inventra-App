import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:inventra/config/app_colors.dart';
import 'package:inventra/config/app_text.dart';
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
                            // addClient();
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
}