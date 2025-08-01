import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:inventra/config/app_colors.dart';
import 'package:inventra/config/app_text.dart';
import 'package:inventra/widgets/titles.dart';
import 'package:inventra/widgets/button.dart';
import 'package:intl/intl.dart';

class TaxpayerPage extends StatefulWidget {
  const TaxpayerPage({super.key});

  @override
  State<TaxpayerPage> createState() => _TaxpayerPageState();
}

class _TaxpayerPageState extends State<TaxpayerPage> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController businessPartnerController =
      TextEditingController();
  final TextEditingController businessTINController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController invoiceNumberController = TextEditingController();
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
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

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

  // BUSINESS PARTNER OPTIONS
  String selectedBusinessPartner = "Customer";
  final List<String> businessPartnerOptions = [
    'Customer',
    'Supplier',
    "Exempt"
  ];
  List<Map<String, dynamic>> partners = [];
  List<Map<String, dynamic>> filteredPartners = [];

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

  // ITEMS OPTIONS
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    priceController.addListener(_updateTotalAmount);
    quantityController.addListener(_updateTotalAmount);
    filteredItems = items;
  }

  // filter items added
  // Add this function to filter items based on search
  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = List.from(items);
      } else {
        filteredItems = items
            .where((item) =>
                item[1].toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // Date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (date != null) {
      setState(() {
        // Format the picked date and display it in the text field
        dateController.text = DateFormat('yyyy-MM-dd').format(date);
        selectedDate = date;
      });
    }
  }

  // Time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (time != null) {
      // Format the TimeOfDay manually to 'HH:mm'
      final String formattedTime = time.format(context);

      setState(() {
        timeController.text = formattedTime;
        selectedTime = time;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: const Color.fromRGBO(62, 180, 137, 1),
        body: Container(
          // constraints: const BoxConstraints(maxWidth: double.infinity),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              // Color.fromRGBO(123, 104, 238, 1),
              // Color.fromRGBO(186, 85, 211, 0.8),
              // Color.fromRGBO(255, 192, 203, 1),
              AppColors.primary,
              AppColors.secondary,
              AppColors.accent
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          )),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    FormField<String>(validator: (value) {
                      if (selectedFlag == null) {
                        return 'Please select an invoice type';
                      }
                      return null;
                    }, builder: (FormFieldState<String> state) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            appTitle(
                              title: AppText.taxpayerTitle,
                            ),
                            const SizedBox(height: 20.0),
                            appTitle(
                              title: AppText.invoiceDate,
                            ),

                            // Invoice Date
                            Row(
                              children: [
                                Expanded(
                                  child: Form(
                                    child: TextFormField(
                                      readOnly: true,
                                      enabled: false,
                                      controller: dateController,
                                      decoration: InputDecoration(
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        labelText: AppText.invoiceDate,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none),
                                      ),
                                      onChanged: (value) {
                                        print('Invoice Date: $value');
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                IconButton(
                                    onPressed: () {
                                      _selectDate(context);
                                    },
                                    icon: const Icon(Icons.calendar_today))
                              ],
                            ),

                            // Invoice Time
                            Row(
                              children: [
                                Expanded(
                                  child: Form(
                                    child: TextFormField(
                                      readOnly: true,
                                      enabled: false,
                                      controller: timeController,
                                      decoration: InputDecoration(
                                        labelText: AppText.invoiceTime,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none),
                                      ),
                                      onChanged: (value) {
                                        print('Invoice Time: $value');
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                IconButton(
                                    onPressed: () {
                                      _selectTime(context);
                                    },
                                    icon: const Icon(Icons.timer))
                              ],
                            ),
                            appTitle(
                              title: AppText.documentType,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          Wrap(
                                spacing: 12.0,
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
                                              color: AppColors.white,
                                              size: 20,
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
                            const SizedBox(height: 20),

                            // Business Partner section
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your business name';
                                      }
                                      return null;
                                    },
                                    controller: businessPartnerController,
                                    decoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      labelText: 'Business Partner',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                appButton(
                                  buttonText: AppText.addClientButton,
                                  onTap: () {},
                                  // size: const Size(110, 55),
                                  colors: AppColors.buttonPrimary,
                                  // fontSize: 16,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: _showBusinessModal,
                                ),
                              ],
                            ),
                            Gap(20.h),

                            // Business TIN text field
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppText.companyTINError;
                                }
                                if (value.length < 11) {
                                  return AppText.validCompanyTINError;
                                }
                                return null;
                              },
                              controller: businessTINController,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                labelText: 'Business TIN',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Gap(20.h),

                            //Username text field
                            Form(
                              child: TextFormField(
                                controller: usernameController,
                                enabled: false,
                                decoration: InputDecoration(
                                    labelText: 'Username',
                                    disabledBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                            ),
                            Gap(20.h),

                            // Invoice number text field
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppText.invoiceNumberError;
                                }
                                return null;
                              },
                              controller: invoiceNumberController,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                labelText: AppText.invoiceNumberField,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Total amount text field
                            Form(
                              child: TextFormField(
                                readOnly: true,
                                enabled: false,
                                controller: totalAmountController,
                                onChanged: (value) {
                                  _updateTotalAmount();
                                },
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: InputDecoration(
                                  disabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  labelText: AppText.totalAmountField,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            appTitle(title: 'Items'),
                            const SizedBox(height: 15),

                            //Item section
                            Row(
                              children: [
                                Expanded(
                                  child: Form(
                                    child: TextFormField(
                                      controller: itemNameController,
                                      onChanged: _filterItems,
                                      decoration: InputDecoration(
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        labelText: AppText.itemField,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                appButton(
                                  buttonText: AppText.addItemButton,
                                  //FIX THIS LATER
                                  onTap: _addItems,

                                  // size: const Size(110, 55),
                                  colors: AppColors.buttonPrimary,
                                  // fontSize: 17,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: showItemMOdal,
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            // buildItemsList(),

                            filteredItems.isNotEmpty
                                ? Expanded(
                                    child: ListView.builder(
                                      itemCount: filteredItems.length,
                                      itemBuilder: (context, index) {
                                        final item = filteredItems[index];
                                        return ListTile(
                                          title: Text(item['name']),
                                          subtitle:
                                              Text('Price: \$${item['price']}'),
                                        );
                                      },
                                    ),
                                  )
                                : Center(
                                    child: appParagraph(
                                      title: "No items found",
                                      fontSize: 17,
                                    ),
                                  ),
                            const SizedBox(
                              height: 5,
                            ),

                            // Quantity text field
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter quantity';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              controller: quantityController,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                labelText: 'Quantity',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Price text field
                            Form(
                                child: TextFormField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              controller: priceController,
                              decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  labelText: "Price",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            )),
                            const SizedBox(
                              height: 15,
                            ),

                            Center(
                              child: appButton(
                                buttonText: 'Submit Invoice',
                                onTap: _submitForm,
                                // size: const Size(160, 55),
                                colors: AppColors.buttonPrimary,
                                // fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            )
                          ]);
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // To validate the date and time
  void _showAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // backgroundColor: AppColors.error,
            title: appTitle(
              title: "INVALID DATE & TIME",
              color: AppColors.info,
              fontWeight: FontWeight.w600,
            ),
            actions: [
              appButton(
                  buttonText: "Close",
                  colors: AppColors.buttonPrimary,
                  onTap: () {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  // Function to submit the form or payload
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // const CircularProgressIndicator(
      //   value: 1,
      //   semanticsLabel: "Hi",
      // );
      print('Form is valid, submitting...');
    }

    // Check for flag
    if (selectedFlag == null) {
      setState(() {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                // backgroundColor: AppColors.error,
                title: appTitle(
                  title: "PLEASE SELECT AN INVOICE TYPE",
                  color: AppColors.info,
                  fontWeight: FontWeight.w600,
                ),
                actions: [
                  appButton(
                      buttonText: "Close",
                      colors: AppColors.buttonPrimary,
                      onTap: () {
                        Navigator.pop(context);
                      })
                ],
              );
            });
        // errorText = 'Please select an option before submitting';
      });
    } else {
      return;
    }

    // Check if date is selected
    if (selectedDate == null) {
      _showAlert();
      return;
    }

    // Check if time is selected
    if (selectedTime == null) {
      _showAlert();
      return;
    }

    // Simulate a delay to show loading spinner
    Future.delayed(const Duration(seconds: 1)).then((value) {
      const CircularProgressIndicator(
        value: 0,
      );

      // Mock data for the invoice payload
      final invoicePayload = {
        'transactionDate': dateController,
        'transactionTime': timeController,
        'businessTin': businessTINController.text,
        'businessName': businessPartnerController.text,
        'businessPartner': businessPartnerController.text,
        'flag': flags,
        'username': usernameController.text,
        'invoiceNumber': invoiceNumberController.text,
        'totalAmount': totalAmountController.text,
        'items': items,
        'quantity': quantityController.text,
        'price': priceController.text,
      };
    });
  }

  // show the item modal
  void showItemMOdal() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Container(
                constraints: const BoxConstraints(maxWidth: 650),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      appTitle(
                        title: AppText.itemSetupTitle,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 10),

                      // Item Code Field
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppText.noItemCodeError;
                          } if(int.tryParse(value) == null) {
                            return AppText.itemCodeDescription;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: AppText.itemCodeField,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Item Name Field
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppText.invalidItemNameError;
                          }
                          return null;
                        },
                        controller: itemNameController,
                        decoration: InputDecoration(
                          labelText: AppText.itemField,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Price Field
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppText.priceIsEmptyError;
                          }
                          return null;
                        },
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: AppText.priceField,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Currency Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedCurrency,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'Currency',
                        ),
                        items: currencyOptions.map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                      const SizedBox(height: 15),

                      // Tax Inclusive Checkbox
                      CheckboxListTile(
                        title: appParagraph(title: "Tax Inclusive?"),
                        value: isTaxInclusive,
                        onChanged: (_) {},
                      ),

                      // Item Description Field
                      TextFormField(
                        controller: itemDescriptionController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Item Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Taxable Checkbox
                      CheckboxListTile(
                        title: appParagraph(title: "Taxable?"),
                        value: isTaxable,
                        onChanged: (_) {},
                      ),

                      // Tourism/CST Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedTourismOrCST,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'Tourism/CST',
                        ),
                        items: tourismOrCSTOptions.map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                      const SizedBox(height: 15),

                      // Item Category Dropdown
                      DropdownButtonFormField<String>(
                        value: selectedItemCategory,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'Item Category',
                        ),
                        items: itemCategoryOptions.map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                      const SizedBox(height: 15),

                      // Discount Checkbox
                      CheckboxListTile(
                        title: appParagraph(title: "Apply Discount"),
                        value: isDiscount,
                        onChanged: (_) {},
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
                appButton(
                  buttonText: "Add Item",
                  // fontSize: 17,
                  onTap: () {
                    // _addItems;
                    Navigator.pop(context);
                  },
                  colors: AppColors.buttonPrimary,
                ),
              ]);
        });
  }

  // Adds new items to the items list
  Future<bool> _addItems() async {
   throw AboutDialog();
  //   try {
  //     // Get the businessPartnerTIN from auth
  //     // final businessPartnerTIN = await ItemService.getBusinessPartnerTIN();

  //     // Create the item object
  //     // final item = Item(
  //     //   itemCode: int.parse(itemCodeController.text),
  //     //   itemName: itemNameController.text,
  //     //   price: int.parse(priceController.text),
  //     //   isTaxInclusive: isTaxInclusive,
  //     //   itemDescription: itemDescriptionController.text,
  //     //   isTaxable: isTaxable,
  //     //   tourismCstOption: selectedTourismOrCST,
  //     //   itemCategory: selectedItemCategory,
  //     //   isDiscountable: isDiscount,
  //     //   businessPartnerTIN: businessPartnerTIN,
  //     // );

  //     // final result = await ItemService.createItem(item);
  //     // if(result) {
  //     //   _clearForm();
  //     // }
  //     // return result;
  //   } catch(e) {
  //     print("Error adding items: $e");
  //     return false;
  //   }
  // }

  // void _clearForm() {
  //   itemCodeController.clear();
  //   itemNameController.clear();
  //   priceController.clear();
  //   itemDescriptionController.clear();
  //   isTaxInclusive = false;
  //   isTaxable = false;
  //   selectedTourismOrCST = 'None';
  //   selectedItemCategory = 'General';
  //   isDiscount = false;
  }

  // Filter items based on the search text
  Widget buildItemsList() {
    return filteredItems.isNotEmpty
        ? Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(item["name"]), // Item name
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price: \$${item["price"]}'),
                        // Text('Category: ${item[7]}'),
                        // if (item["3"].isNotEmpty)
                        //   Text('Description: ${item[3]}'),
                        // Text('Tax Inclusive: ${item[4] ? "Yes" : "No"}'),
                        // Text('Taxable: ${item[5] ? "Yes" : "No"}'),
                        // if (item[] != "None") Text('Tourism/CST: ${item[6]}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          items.removeAt(index);
                          filteredItems = items;
                        });
                      },
                    ),
                    onTap: () {
                      // Optionally add item selection logic here
                      // For example, populate the main form with this item's details
                      itemNameController.text = item[1];
                      priceController.text = item[2];
                      // ... populate other fields as needed
                    },
                  ),
                );
              },
            ),
          )
        : const Center(
            child: Text(
              'No items found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
  }

  // Shows the Business Modal
  void _showBusinessModal() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Setup a Business Partner",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Business Partner text field
                  TextFormField(
                    controller: businessPartnerController,
                    decoration: InputDecoration(
                      labelText: 'Business Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // VAT Type Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedBusinessPartner,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Type',
                    ),
                    items: businessPartnerOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBusinessPartner = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 15),

                  // Business TIN text field
                  TextFormField(
                    controller: businessTINController,
                    decoration: InputDecoration(
                      labelText: 'Business TIN',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Email text field
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Phone Number text field
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: contactController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
              appButton(
                buttonText: AppText.addClientButton,
                onTap: () {
                  _addPartner();
                  Navigator.pop(context);
                },
                colors: AppColors.buttonPrimary,
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     _addPartner;
              //     Navigator.pop(context);
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.blueGrey,
              //   ),
              //   child: const Text("Add"),
              // ),
            ],
          );
        });
  }

  void _addPartner() {
    if (businessPartnerController.text.isEmpty &&
        businessTINController.text.isEmpty &&
        emailController.text.isEmpty &&
        contactController.text.isEmpty) {
      "Please fill in the required fields";
    }

    final newPartner = {
      'businessName': businessPartnerController.text,
      'businessTIN': businessTINController.text,
      'businessOptions': businessPartnerOptions,
      'email': emailController.text,
      'contact': contactController.text,
    };

    partners.add(newPartner);

    setState(() {
      // itemNameController.clear();
      // priceController.clear();
      // currencyController.clear();
      // isTaxInclusive = true;
      // itemDescriptionController.clear();
      // isTaxable = true;
      // selectedTourismOrCST = "None";
      // selectedItemCategory = "Regular VAT";
    });
  }

  // Shows the updated total amount
  void _updateTotalAmount() {
    final double price = double.tryParse(priceController.text) ?? 0.0;
    final int quantity = int.tryParse(quantityController.text) ?? 0;
    final double totalAmount = price * quantity;
    totalAmountController.text = totalAmount.toStringAsFixed(2);
  }

  @override
  void dispose() {
    priceController.removeListener(_updateTotalAmount);
    quantityController.removeListener(_updateTotalAmount);
    priceController.dispose();
    quantityController.dispose();
    totalAmountController.dispose();
    super.dispose();
  }
}
