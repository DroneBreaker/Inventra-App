import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventra/widgets/app_text.dart';
import 'package:inventra/widgets/button.dart';

class CreateAdvanceIncome extends StatefulWidget {
  const CreateAdvanceIncome({super.key});

  @override
  State<CreateAdvanceIncome> createState() => _CreateAdvanceIncomeState();
}

class _CreateAdvanceIncomeState extends State<CreateAdvanceIncome> {
  // Controllers
  final TextEditingController clientIDController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController= TextEditingController();
  final TextEditingController dateReceivedController = TextEditingController();
  final TextEditingController expectedDeliveryDateController = TextEditingController();
  final TextEditingController appliedAmountController= TextEditingController();

  final _formKey = GlobalKey<FormState>();


  // DATE OPTIONS
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Date picker for Date Received
  Future<void> _selectDateReceived(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (date != null) {
      setState(() {
        // Format the picked date and display it in the text field
        dateReceivedController.text = DateFormat('yyyy-MM-dd').format(date);
        selectedDate = date;
      });
    }
  }

  // Date picker for Expected Delivery
  Future<void> _selectExpectedDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (date != null) {
      setState(() {
        // Format the picked date and display it in the text field
        expectedDeliveryDateController.text = DateFormat('yyyy-MM-dd').format(date);
        selectedDate = date;
      });
    }
  }

  // STATUS OPTIONS
  String selectedStatusOptions = "Pending";

  final statusOptions = [
    "Pending",
    "Partially Applied",
    "Fully Applied"
  ];


  bool _isRecurring = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Center
                      (
                        child: 
                          AppText(title: "ADVANCE INVOICE FUCKERS")
                      ),
                      SizedBox(height: 20,),
          
          
                      // Client ID TExtForm field
                      TextFormField(
                        controller: clientIDController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          hintText: "Client ID"
                        ),
                      ),
                      SizedBox(height: 20),
          
          
                      // Amount TextForm field
                      TextFormField(
                        controller: amountController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          hintText: "Amount"
                        ),
                      ),
                      SizedBox(height: 20,),
          
          
                      // Description TextForm field
                      TextFormField(
                        controller: descriptionController,
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          contentPadding: EdgeInsets.only(top: 40, left: 20),
                          hintText: "Description"
                        ),
                      ),
                      SizedBox(height: 20,),
          
          
                      // Date received TextForm field
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              child: TextFormField(
                                controller: dateReceivedController,
                                keyboardType: TextInputType.datetime,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  contentPadding: EdgeInsets.only(top: 40, left: 20),
                                  hintText: "Date Received"
                                ),
                                onChanged: (value) {
                                  print('Date Received: $value');
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          IconButton(onPressed: () => _selectDateReceived(context), icon: Icon(Icons.calendar_month, size: 30,))
                        ],
                      ),
                      SizedBox(height: 20,),
          
          
                      // Expected Delivery Date TextForm field
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              child: TextFormField(
                                  controller: expectedDeliveryDateController,
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    contentPadding: EdgeInsets.only(top: 40, left: 20),
                                    hintText: "Expected Delivery"
                                  ),
                                  onChanged: (value) {
                                    print('Expected Delivery Date: $value');
                                  },
                                ),
                            ),
                          ),
                          IconButton(onPressed: () => _selectExpectedDate(context), 
                            icon: Icon(Icons.calendar_month, size: 30,)
                          )
                        ],
                      ),
                      SizedBox(height: 20,),
          
          
                      // Status TextForm field
                      DropdownButtonFormField(
                            value: selectedStatusOptions,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'Status',
                            ),
                            items: statusOptions.map((String option) {
                              return DropdownMenuItem(
                                value: option,
                                child: AppText(title: option,),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if(newValue != null) {
                                setState(() {
                                  selectedStatusOptions = newValue;
                                });
                              }
                            },
                          ),
                          SizedBox(height: 20,),
          
          
                          // Amount TextForm field
                          TextFormField(
                            controller: appliedAmountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              contentPadding: EdgeInsets.only(top: 40, left: 20),
                              hintText: "Applied Amount"
                            ),
                          ),
                          SizedBox(height: 20,),


                          // Related Invoices
                          // Recurring Option
                          SwitchListTile(
                            title: Text('Recurring Advance'),
                            subtitle: Text('Is this a recurring advance payment?'),
                            value: _isRecurring,
                            onChanged: (bool value) {
                              setState(() {
                                _isRecurring = value;
                              });
                            },
                          ),



                          // Button
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                // handleAdvanceIncome();
                              }, 
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey
                              ),
                              child: AppText(title: "Submit", colors: Colors.white, fontSize: 18,),)
                          )
                      
          
                      // pub struct AdvanceIncome {
              
              // pub related_invoices: Vec<String>,
             
          // }
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