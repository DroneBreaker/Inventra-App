import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventra/constants/app_colors.dart';
import 'package:inventra/constants/app_titles.dart';
import 'package:inventra/widgets/app_text.dart';
import 'package:inventra/widgets/button.dart';

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



@override
void initState() {
  super.initState();
  // Initialize filtered clients
  filteredClients = List.from(clients);
  
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
                                AppText(title: "INVOICE FUCKERS"),
                                SizedBox(height: 10,),
                            

                                // Document Type
                                AppText(title: "Select Document Type", fontSize: 17,),
                                SizedBox(height: 10,),

                                
                                // INVOICE FLAGS
                                Wrap(
                                      spacing: 25.0,
                                      runSpacing: 12.0,
                                      children: flags.map((flag) {
                                        final bool isActive =
                                            activeButton == flag['text'];
                                        return Button(
                                            
                                              buttonText: flag['text'],
                                              onTap: () {
                                                setState(() {
                                                  activeButton = flag['text'];
                                                  selectedFlag = flag['text'];
                                                });
                                                                      
                                                state.didChange(flag['text']);
                                              },
                                              colors: AppColors.buttonPrimary,
                                              fontSize: 16,
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
                                SizedBox(height: 20,),
                            
                            
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
                            
                            
                                // Username TextForm field
                                TextFormField(
                                  controller: usernameController,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 20),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    hintText: "Username"
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
                                ),
                                SizedBox(height: 20,),
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
}