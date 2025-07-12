import 'package:flutter/material.dart';
import 'package:inventra/config/app_text.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
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
                      SizedBox(height: 20,),
            

                      // Customer Name TextForm field
                      TextFormField(
                        controller: customerNameTextController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          contentPadding: EdgeInsets.only(left: 20),
                          hintText: "Customer Name"
                        ),
                      ),
                      SizedBox(height: 20,),


                      // Customer TIN TextForm field
                      TextFormField(
                        controller: customerTINTextController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          contentPadding: EdgeInsets.only(left: 20),
                          hintText: "Customer TIN"
                        ),
                      ),
                      SizedBox(height: 20,),


                      // Customer Email TextForm field
                      TextFormField(
                        controller: emailTextController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          contentPadding: EdgeInsets.only(left: 20),
                          hintText: "Email"
                        ),
                      ),
                      SizedBox(height: 20,),


                      // Client Type
                      DropdownButtonFormField(
                        value: selectedClientType,
                        decoration: InputDecoration(
                          labelText: 'Client Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                        items: clientType.map((String option) {
                          return DropdownMenuItem(
                            value: option,
                            child: appTitle(title: option)
                          );
                        }).toList(), 
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedClientType = newValue;
                            });
                          }
                        }
                      ),
                      SizedBox(height: 20,),


                      // Customer Phone TextForm field
                      TextFormField(
                        controller: phoneTextController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          contentPadding: EdgeInsets.only(left: 20),
                          hintText: "Phone Number"
                        ),
                      ),
                      SizedBox(height: 20,),


                      // Button
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(),
                          onPressed: () {
                            // addClient();
                          }, 
                          child: appTitle(title: AppText.addClientButton)
                        )
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ),
    );
  }
}