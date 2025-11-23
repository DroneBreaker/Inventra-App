import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:inventra/config/app_colors.dart';
import 'package:inventra/config/app_text.dart';
import 'package:inventra/widgets/forms.dart';
import 'package:inventra/widgets/titles.dart';
import 'package:inventra/widgets/button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class CreateInvoice extends StatefulWidget {
  const CreateInvoice({super.key});

  @override
  State<CreateInvoice> createState() => _CreateInvoiceState();
}

class _CreateInvoiceState extends State<CreateInvoice> {
  final TextEditingController invoiceNumberController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
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
        invoiceTimeController.text = formattedTime;
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
  
  // Enhanced client management
  List<Map<String, dynamic>> clients = [
    {'name': 'John Doe', 'tin': 'TIN001'},
    {'name': 'Jane Smith', 'tin': 'TIN002'},
    {'name': 'Acme Corporation', 'tin': 'TIN003'},
    {'name': 'Tech Solutions Ltd', 'tin': 'TIN004'},
  ];
  List<Map<String, dynamic>> filteredClients = [];
  bool showClientDropdown = false;
  Map<String, dynamic>? selectedClientData;
  

  // FLAG OPTIONS
  String? selectedFlag;
  final List<Map<String, dynamic>> flags = [
    {
      'text': 'Invoice',
      'icon': Icons.receipt_long,
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


  // Add this to your _CreateInvoiceState class

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      usernameController.text = prefs.getString('username') ?? '';
    });
  }



  @override
  void initState() {
    super.initState();
    // Initialize filtered clients
    filteredClients = List.from(clients);
    _loadUserData();
    
    // Add listener to client name controller
    clientNameController.addListener(_onClientNameChanged);
  }

  @override
  void dispose() {
    clientNameController.removeListener(_onClientNameChanged);
    super.dispose();
  }

  void _onClientNameChanged() {
  final query = clientNameController.text.toLowerCase();
  
  setState(() {
    if (query.isEmpty) {
      filteredClients = List.from(clients);
      showClientDropdown = false;
      selectedClientData = null;
      clientTINController.clear();
    } else {
      filteredClients = clients.where((client) {
        return client['name'].toLowerCase().contains(query);
      }).toList();
      showClientDropdown = filteredClients.isNotEmpty;
      
      // Check if current text exactly matches a client name
      final exactMatch = clients.firstWhere(
        (client) => client['name'].toLowerCase() == query,
        orElse: () => {},
      );
      
      if (exactMatch.isNotEmpty && selectedClientData?['name'] != exactMatch['name']) {
        selectedClientData = exactMatch;
        clientTINController.text = exactMatch['tin'];
      }
    }
  });
}

  void _selectClient(Map<String, dynamic> client) {
  setState(() {
    selectedClientData = client;
    clientNameController.text = client['name'];
    clientTINController.text = client['tin'];
    showClientDropdown = false;
  });
}

  // Replace your existing Client Name and Client TIN TextFormFields with this:
  Widget buildClientSelection() {
  return Column(
    children: [
      // Client Name with dropdown
      Stack(
        children: [
          TextFormField(
            controller: clientNameController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              hintText: "Client Name",
              suffixIcon: clientNameController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        clientNameController.clear();
                        clientTINController.clear();
                        setState(() {
                          showClientDropdown = false;
                          selectedClientData = null;
                        });
                      },
                      icon: Icon(Icons.clear),
                    )
                  : Icon(Icons.search),
            ),
            onTap: () {
              if (clientNameController.text.isNotEmpty) {
                setState(() {
                  showClientDropdown = true;
                });
              }
            },
          ),
          
          // Dropdown suggestions
          if (showClientDropdown && filteredClients.isNotEmpty)
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  constraints: BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredClients.length,
                    itemBuilder: (context, index) {
                      final client = filteredClients[index];
                      return ListTile(
                        title: Text(client['name']),
                        subtitle: Text('TIN: ${client['tin']}'),
                        onTap: () => _selectClient(client),
                        dense: true,
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
      
      SizedBox(height: 20),
      
      // Client TIN (auto-populated)
      TextFormField(
        controller: clientTINController,
        enabled: false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          hintText: "Client TIN",
          filled: true,
          fillColor: selectedClientData != null ? Colors.green.shade50 : Colors.grey.shade100,
        ),
      ),
    ],
  );
}

  // In your build method, replace the existing Client Name and Client TIN sections with:
  // _buildClientSelection(),


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
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back, size: 40,)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20, top: 70),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          FormField<String>(validator: (value) {
                            if (selectedFlag == null) {
                              return 'Please select an invoice type';
                            }
                            return null;
                          }, 
                          builder: (FormFieldState<String> state) {
                            return Column(
                              children: [
                                appTitle(title: "INVOICE FUCKERS"),
                                SizedBox(height: 10,),
                            

                                // Document Type
                                appTitle(title: "Select Document Type",),
                                SizedBox(height: 10,),

                                
                                // INVOICE FLAGS
                                Wrap(
                                      spacing: 25.0,
                                      runSpacing: 12.0,
                                      children: flags.map((flag) {
                                        final bool isActive =
                                            activeButton == flag['text'];
                                        return appButton(
                                            
                                              buttonText: flag['text'],
                                              onTap: () {
                                                setState(() {
                                                  activeButton = flag['text'];
                                                  selectedFlag = flag['text'];
                                                });
                                                                      
                                                state.didChange(flag['text']);
                                              },
                                              colors: AppColors.buttonPrimary,
                                              // fontSize: 16,
                                              icon: isActive
                                                  ? Icon(
                                                      flag['icon'],
                                                      color: Colors.amber,
                                                      size: 25,
                                                    )
                                                  : null);
                                      }).toList()
                            
                                      // Button(
                                      //   buttonText: "Purchase",
                                      //   onTap: () {},
                                      //   colors: Colors.white,
                                      //   fontSize: 16,
                                      // ),
                                      // Button(
                                      //   buttonText: "Refund",
                                      //   onTap: () {},
                                      //   colors: Colors.white,
                                      //   fontSize: 16,
                                      // ),
                                      // Button(
                                      //   buttonText: "Credit Note",
                                      //   onTap: () {},
                                      //   colors: Colors.white,
                                      //   fontSize: 16,
                                      // ),
                                ),
                                Gap(20.h),
                            
                            
                                // Invoice Number TextForm field
                                appInput(placeholder: "Invoice Number", textEditingController: invoiceNumberController, 
                                  errorMsg: AppText.invoiceNumberError, errorLengthMsg: AppText.invoiceNumberLengthError
                                ),
                                Gap(20.h),
                            
                            
                                // Username TextForm field
                                appInput(placeholder: "Username", textEditingController: usernameController, isEnabled: false),
                                Gap(20.h),
                            
                            
                                // Client TextForm field
                                appInput(placeholder: "Client Name", textEditingController: clientNameController),
                                Gap(20.h),
                            
                            
                                // Client TIN
                                appInput(placeholder: "Client TIN", textEditingController: clientTINController, isEnabled: false),
                                Gap(20.h),
                            
                            
                                // Invoice Date TextForm field
                                Row(
                                  children: [
                                    Expanded(
                                      child: appInput(placeholder: "Invoice Date", textEditingController: 
                                      invoiceDateController, textInputType: TextInputType.datetime, onTap: (value) => print('Invoice Time: $value')
                                    ),
                                    ),
                                    IconButton(onPressed: () => _selectInvoiceDate(context), 
                                      icon: Icon(Icons.calendar_month, size: 30,)
                                    )
                                  ],
                                ),
                                Gap(20.h),
                            
                            
                                // Invoice Time TextForm field
                                Row(
                                  children: [
                                    Expanded(
                                      child: Form(
                                        child: appInput(placeholder: "Invoice Time", textEditingController: invoiceTimeController, 
                                          onTap: (value) => print('Invoice Time: $value')
                                        )
                                      ),
                                    ),
                                    IconButton(onPressed: () => _selectInvoiceTime(context), 
                                      icon: Icon(Icons.calendar_month, size: 30,)
                                    )
                                  ],
                                ),
                                Gap(20.h),





                      //           Row(
                      //   children: [
                      //     Expanded(
                      //       child: Form(
                      //         child: TextFormField(
                      //           controller: dateReceivedController,
                      //           keyboardType: TextInputType.datetime,
                      //           decoration: InputDecoration(
                      //             border: OutlineInputBorder(
                      //               borderRadius: BorderRadius.circular(10)
                      //             ),
                      //             contentPadding: EdgeInsets.only(top: 40, left: 20),
                      //             hintText: "Date Received"
                      //           ),
                      //           onChanged: (value) {
                      //             print('Date Received: $value');
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      //     Gap(15.w),
                      //     IconButton(onPressed: () => _selectDateReceived(context), icon: Icon(Icons.calendar_month, size: 30,))
                      //   ],
                      // ),
                            
                            
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
                                              contentPadding: EdgeInsets.only(left: 20),
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
                                Gap(20.h),
                            
                            
                                // Total VAT TextForm field
                                appInput(placeholder: "Total VAT", textEditingController: totalVATController, isEnabled: false),
                                Gap(20.h),
                            
                            
                                // Total Amount TextForm field
                                appInput(placeholder: "Total Amount", textEditingController: totalAmountController, isEnabled: false),
                                Gap(20.h),
                            
                            
                                // Invoice Status Dropdown
                                // DropdownButtonFormField(
                                //   value: selectedInvoiceStatus,
                                //   decoration: InputDecoration(
                                //     border: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //     ),
                                //     labelText: 'Invoice Status',
                                //   ),
                                //   items: invoiceStatus.map((String option) {
                                //     return DropdownMenuItem(
                                //       value: option,
                                //       child: Text(option),
                                //     );
                                //   }).toList(),
                                //   onChanged: (String? newValue) {
                                //     if(newValue != null) {
                                //       setState(() {
                                //         selectedItemCategory = newValue;
                                //       });
                                //     }
                                //   },
                                // ),
                                // Gap(20.h),
                            
                            
                                // Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 60,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange[400]
                                    ),
                                    onPressed: () {
                                      handleInvoice();
                                    }, 
                                    child: appParagraph(title: "Submit", fontSize: 17, color: AppColors.white,)
                                  ),
                                ),
                               Gap(40.h),
                              ],
                            );
                          }),
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

  



































  void handleInvoice() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Additional validation for required fields
    if (!_validateRequiredFields()) {
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Prepare invoice data
      final invoiceData = await _prepareInvoiceData();

      // Send to API
      final response = await _sendInvoiceToAPI(invoiceData);

      // Hide loading indicator
      Navigator.of(context).pop();

      if (response['success'] == true) {
        // Success - show success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invoice created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear form or navigate back
        _clearForm();
        Navigator.of(context).pop();
      } else {
        // Handle API error
        _showErrorDialog(response['message'] ?? 'Failed to create invoice');
      }
    } catch (e) {
      // Hide loading indicator if still showing
      Navigator.of(context).pop();
      
      // Handle network or other errors
      _showErrorDialog('Network error: ${e.toString()}');
    }
  }

  bool _validateRequiredFields() {
    List<String> missingFields = [];

    if (selectedFlag == null || selectedFlag!.isEmpty) {
      missingFields.add('Invoice Type');
    }
    if (invoiceNumberController.text.trim().isEmpty) {
      missingFields.add('Invoice Number');
    }
    if (clientNameController.text.trim().isEmpty) {
      missingFields.add('Client Name');
    }
    if (invoiceDateController.text.trim().isEmpty) {
      missingFields.add('Invoice Date');
    }
    if (invoiceTimeController.text.trim().isEmpty) {
      missingFields.add('Invoice Time');
    }
    if (dueDateController.text.trim().isEmpty) {
      missingFields.add('Due Date');
    }

    if (missingFields.isNotEmpty) {
      _showErrorDialog('Please fill the following required fields:\n• ${missingFields.join('\n• ')}');
      return false;
    }

    // Validate dates
    if (selectedInvoiceDate == null) {
      _showErrorDialog('Please select a valid invoice date');
      return false;
    }

    if (selectedDueDate == null) {
      _showErrorDialog('Please select a valid due date');
      return false;
    }

    if (selectedDueDate!.isBefore(selectedInvoiceDate!)) {
      _showErrorDialog('Due date cannot be before invoice date');
      return false;
    }

    return true;
  }

  Future<Map<String, dynamic>> _prepareInvoiceData() async {
    // final uuid = const Uuid();
    final prefs = await SharedPreferences.getInstance();

    // Convert flag text to enum value
    String flagValue = _convertFlagToEnum(selectedFlag!);

    // Combine date and time for invoice_time
    DateTime invoiceDateTime = DateTime(
      selectedInvoiceDate!.year,
      selectedInvoiceDate!.month,
      selectedInvoiceDate!.day,
      selectedInvoiceTime?.hour ?? 0,
      selectedInvoiceTime?.minute ?? 0,
    );

    // Prepare invoice data matching your Rust model
    final invoiceData = {
      // "id": uuid.v4(),
      "flag": flagValue,
      "invoice_number": invoiceNumberController.text.trim(),
      "username": usernameController.text.trim(),
      "company_tin": prefs.getString('company_tin') ?? "C000713911X", // Get from SharedPreferences or config
      "client_name": clientNameController.text.trim(),
      "client_tin": clientTINController.text.trim().isEmpty ? "0000000000" : clientTINController.text.trim(),
      "invoice_date": selectedInvoiceDate!.toUtc().toIso8601String(),
      "invoice_time": invoiceDateTime.toUtc().toIso8601String(),
      "due_date": selectedDueDate!.toUtc().toIso8601String(),
      "total_vat": _parseDecimal(totalVATController.text),
      "total_amount": _parseDecimal(totalAmountController.text),
      "items": [], // You'll need to add items collection logic
      "created_at": DateTime.now().toUtc().toIso8601String(),
      "updated_at": DateTime.now().toUtc().toIso8601String(),
    };

    return invoiceData;
  }

  String _convertFlagToEnum(String flag) {
    switch (flag) {
      case 'Invoice':
        return 'Invoice';
      case 'Purchase':
        return 'Purchase';
      case 'Refund':
        return 'PartialRefund'; // You might want to add logic to determine Partial vs Full
      case 'Credit Note':
        return 'CreditNote';
      default:
        return 'Invoice';
    }
  }

  double _parseDecimal(String value) {
    if (value.trim().isEmpty) return 0.0;
    try {
      return double.parse(value.trim());
    } catch (e) {
      return 0.0;
    }
  }

  Future<Map<String, dynamic>> _sendInvoiceToAPI(Map<String, dynamic> invoiceData) async {
    const String baseUrl = 'https://vsdcstaging.vat-gh.com/vsdc/api/v1/taxpayer';
    const String reference = 'C000713911X-002';
    const String securityKey = 'IWhnuThonHN9VY1xuQO5VV/s5/PR2v3bcdDr0SmAwiI3JjMSK39WpXsmSU9wEwqv';
    
    final String endpoint = '$baseUrl/$reference/invoice';

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $securityKey', // or however the security key should be sent
          'X-Security-Key': securityKey, // Alternative header format if needed
        },
        body: json.encode(invoiceData),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        return {
          'success': true,
          'data': responseData,
          'message': 'Invoice created successfully'
        };
      } else {
        String errorMessage = 'Failed to create invoice';
        try {
          final errorData = json.decode(response.body);
          errorMessage = errorData['message'] ?? errorData['error'] ?? errorMessage;
        } catch (e) {
          errorMessage = 'HTTP ${response.statusCode}: ${response.reasonPhrase}';
        }
        
        return {
          'success': false,
          'message': errorMessage,
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}'
      };
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    // Clear all controllers
    invoiceNumberController.clear();
    clientNameController.clear();
    clientTINController.clear();
    invoiceDateController.clear();
    invoiceTimeController.clear();
    dueDateController.clear();
    totalVATController.clear();
    totalAmountController.clear();

    // Reset state variables
    setState(() {
      selectedFlag = null;
      activeButton = '';
      selectedInvoiceDate = null;
      selectedDueDate = null;
      selectedInvoiceTime = null;
      selectedClientData = null;
      showClientDropdown = false;
    });
  }

  // Helper method to validate invoice number format (add your own logic)
  bool _isValidInvoiceNumber(String invoiceNumber) {
    // Add your invoice number validation logic here
    // For example, check format, uniqueness, etc.
    return invoiceNumber.trim().isNotEmpty && invoiceNumber.trim().length >= 3;
  }

  // Helper method to validate TIN format
  bool _isValidTIN(String tin) {
    // Add your TIN validation logic here
    if (tin.trim().isEmpty) return true; // Optional field
    return tin.trim().length >= 9; // Example validation
  }
}
