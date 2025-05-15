import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventra/constants/app_titles.dart';
import 'package:inventra/widgets/app_text.dart';

class CreateInvoice extends StatefulWidget {
  const CreateInvoice({super.key});

  @override
  State<CreateInvoice> createState() => _CreateInvoiceState();
}

class _CreateInvoiceState extends State<CreateInvoice> {
  final TextEditingController invoiceNumberController = TextEditingController();
  final TextEditingController sellerController = TextEditingController();
  final TextEditingController clientNameController =
      TextEditingController();
  final TextEditingController clientTINController = TextEditingController();
  final TextEditingController invoiceDateController = TextEditingController();
  final TextEditingController invoiceTimeController = TextEditingController();
  final TextEditingController dueDateController= TextEditingController();
  final TextEditingController totalVATController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController itemCodeController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemDescriptionController =
      TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // DATE OPTIONS
  DateTime? selectedInvoiceDate;
  DateTime? selectedDueDate;
  TimeOfDay? selectedInvoiceTime;

  // invoice Date picker
  Future<void> _selectInvoiceDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (date != null) {
      setState(() {
        // Format the picked date and display it in the text field
        invoiceDateController.text = DateFormat('yyyy-MM-dd').format(date);
        selectedInvoiceDate = date;
      });
    }
  }


  // Due Date picker
  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (date != null) {
      setState(() {
        // Format the picked date and display it in the text field
        dueDateController.text = DateFormat('yyyy-MM-dd').format(date);
        selectedDueDate = date;
      });
    }
  }

  // Time picker
  Future<void> _selectInvoiceTime(BuildContext context) async {
    final TimeOfDay? time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (time != null) {
      // Format the TimeOfDay manually to 'HH:mm'
      final String formattedTime = time.format(context);

      setState(() {
        invoiceDateController.text = formattedTime;
        selectedInvoiceTime = time;
      });
    }
  }

  // OPTIONS
  bool isTaxInclusive = true;
  bool isTaxable = true;
  bool isDiscount = false;
  bool isActive = false;
  String activeButton = '';

  // CST OR TOURISM OPTIONS
  final List<String> tourismOrCSTOptions = ['None', 'Tourism', 'CST'];
  String selectedTourismOrCST = "None";

  // ITEM CATEGORY OPTIONS
  final List<String> itemCategoryOptions = ['Regular VAT', 'Rent', 'Exempt'];
  String selectedItemCategory = "Regular VAT";

  // CURRENCY OPTIONS
  final List<String> currencyOptions = ["GHS", "USD", "EUR", "GBP"];
  String selectedCurrency = "GHS";

  // CLIENT OPTIONS
  String selectedClient = "Customer";
  final List<String> clientOptions = [
    'Customer',
    'Supplier',
    "Exempt"
  ];
  List<Map<String, dynamic>> clients = [];
  List<Map<String, dynamic>> filteredClients = [];

  // FLAG OPTIONS
  String? selectedFlag;
  final List<Map<String, dynamic>> flags = [
    {
      'text': 'Invoice',
      'icon': Icons.inventory,
    },
    {
      'text': 'Purchase',
      'icon': Icons.shopping_cart,
    },
    {
      'text': 'Refund',
      'icon': Icons.assignment_return,
    },
    {
      'text': 'Credit Note',
      'icon': Icons.note,
    },
  ];

  // INVOICE STATUS OPTIONS
  String selectedInvoiceStatus = "Draft";
  final List<String> invoiceStatus = [
    "Draft",
    "Sent",
    "Paid",
    "Overdue",
    "Canceled",
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 8,
                    child: Icon(Icons.arrow_back, size: 40,),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20, top: 70),
                    child: Form(
                      child: Column(
                        children: [
                          AppText(title: "INVOICE FUCKERS"),
                          SizedBox(height: 10,),
                      

                          // Invoice Number TextForm field
                          TextFormField(
                            controller: invoiceNumberController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: "Invoice Number"
                            ),
                          ),
                          SizedBox(height: 20,),


                          // Seller TextForm field
                          TextFormField(
                            controller: sellerController,
                            enabled: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: "Seller"
                            ),
                          ),
                          SizedBox(height: 20,),


                          // Client TextForm field
                          TextFormField(
                            controller: clientNameController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: "Client Name"
                            ),
                          ),
                          SizedBox(height: 20,),


                          // Client TIN
                          TextFormField(
                            controller: clientTINController,
                            enabled: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: "Client TIN"
                            ),
                          ),
                          SizedBox(height: 20,),


                          // Invoice Date TextForm field
                          Row(
                            children: [
                              Expanded(
                                child: Form(
                                  child: TextFormField(
                                      controller: invoiceDateController,
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        contentPadding: EdgeInsets.only(top: 40, left: 20),
                                        hintText: "Invoice Date"
                                      ),
                                      onChanged: (value) {
                                        print('Invoice Date: $value');
                                      },
                                    ),
                                ),
                              ),
                              IconButton(onPressed: () => _selectInvoiceDate(context), 
                                icon: Icon(Icons.calendar_month, size: 30,)
                              )
                            ],
                          ),
                          SizedBox(height: 20,),


                          // Invoice Time TextForm field
                          Row(
                            children: [
                              Expanded(
                                child: Form(
                                  child: TextFormField(
                                      controller: invoiceTimeController,
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        contentPadding: EdgeInsets.only(top: 40, left: 20),
                                        hintText: "Invoice Time"
                                      ),
                                      onChanged: (value) {
                                        print('Invoice Time: $value');
                                      },
                                    ),
                                ),
                              ),
                              IconButton(onPressed: () => _selectInvoiceTime(context), 
                                icon: Icon(Icons.calendar_month, size: 30,)
                              )
                            ],
                          ),
                          SizedBox(height: 20,),


                          // Due Date TextForm field
                          Row(
                            children: [
                              Expanded(
                                child: Form(
                                  child: TextFormField(
                                      controller: dueDateController,
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        contentPadding: EdgeInsets.only(top: 40, left: 20),
                                        hintText: "Due Date"
                                      ),
                                      onChanged: (value) {
                                        print('Due Date: $value');
                                      },
                                    ),
                                ),
                              ),
                              IconButton(onPressed: () => _selectDueDate(context), 
                                icon: Icon(Icons.calendar_month, size: 30,)
                              )
                            ],
                          ),
                          SizedBox(height: 20,),


                          // Total VAT TextForm field
                          TextFormField(
                            controller: totalVATController,
                            enabled: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: "Total VAT"
                            ),
                          ),
                          SizedBox(height: 20,),


                          // Total Amount TextForm field
                          TextFormField(
                            controller: totalAmountController,
                            enabled: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: "Total Amount"
                            ),
                          ),
                          SizedBox(height: 20,),


                          // Invoice Status Dropdown
                          DropdownButtonFormField(
                            value: selectedInvoiceStatus,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'Invoice Status',
                            ),
                            items: invoiceStatus.map((String option) {
                              return DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if(newValue != null) {
                                setState(() {
                                  selectedItemCategory = newValue;
                                });
                              }
                            },
                          ),
                          SizedBox(height: 20,),


                          // Button
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[400]
                              ),
                              onPressed: () {
                              // handleInvoice();
                              }, 
                              child: AppText(title: "Submit", fontSize: 17, colors: Colors.black,)
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
        ),
          // ),
        )
    );
  }
}