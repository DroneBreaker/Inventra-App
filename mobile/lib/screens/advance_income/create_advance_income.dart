import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:inventra/widgets/forms.dart';
import 'package:inventra/widgets/titles.dart';

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
                          appTitle(title: "ADVANCE INVOICE FUCKERS")
                      ),
                      Gap(20.h),
          
          
                      // Client ID TExtForm field
                      appInput(placeholder: "Client ID", textEditingController: clientIDController),
                      Gap(20.h),
          
          
                      // Amount TextForm field
                      appInput(placeholder: "Amount", textEditingController: amountController, textInputType: TextInputType.number),
                      Gap(20.h),
          
          
                      // Description TextForm field
                      appInput(placeholder: "Description", textEditingController: descriptionController, maxLines: 4),
                      Gap(20.h),
          
          
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
                                  contentPadding: EdgeInsets.only(left: 20),
                                  hintText: "Date Received"
                                ),
                                onChanged: (value) {
                                  print('Date Received: $value');
                                },
                              ),
                            ),
                          ),
                          Gap(15.w),
                          IconButton(onPressed: () => _selectDateReceived(context), icon: Icon(Icons.calendar_month, size: 30,))
                        ],
                      ),
                      Gap(20.h),
          
          
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
                                    contentPadding: EdgeInsets.only(left: 20),
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
                      Gap(20.h),
          
          
                      // Status TextForm field
                          appDropdown(selectedValue: selectedStatusOptions, items: statusOptions),
                          Gap(20.h),
          
          
                          // Amount TextForm field
                          appInput(placeholder: "Applied Amount", textEditingController: amountController, textInputType: TextInputType.number),
                          Gap(20.h),


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
                                backgroundColor: Colors.orange
                              ),
                              child: appParagraph(title: "Submit", color: Colors.white,),)
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
