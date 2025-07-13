// import 'package:flutter/material.dart';
// import 'package:inventra/constants/app_titles.dart';
// import 'package:inventra/widgets/app_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:inventra/config/app_colors.dart';
import 'package:inventra/config/app_text.dart';
import 'package:inventra/services/item_service.dart';
import 'package:inventra/widgets/forms.dart';
import 'package:inventra/widgets/titles.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State createState() => _ItemsPageState();
}

class _ItemsPageState extends State {
  final TextEditingController itemCodeController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemDescriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController companyTINController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  // ITEM CATERGORY
  final itemCategoryOptions = [
    "RegularVAT",
    "Rent",
    "Exempt",
    "NonVAT"
  ];
  String selectedItemCategory = "RegularVAT";

  // TAX INCLUSIVE
  bool isTaxable = false;
  bool isTaxInclusive = true;

   // TOURISM CST CATERGORY
  final tourismCSTOptions = [
    "None",
    "Tourism",
    "CST"
  ];
  String selectedTourismCSTOption = "None";
  
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Center(
                          child: appTitle(title: "HELLO ITEM FUCKERS"),
                        ),
                        const SizedBox(height: 25), 
                        
                        // ItemCode TextForm field
                        appInput(placeholder: "Item Code", textEditingController: itemCodeController, 
                          errorMsg: AppText.noItemCodeError, textInputType: TextInputType.number),
                        Gap(20.h), 


                        // Item Name TextForm field
                        appInput(placeholder: "Item Name", textEditingController: itemNameController, errorMsg: AppText.invalidItemNameError),
                        Gap(20.h), 


                        // Item Description TextForm field
                        appInput(placeholder: "Item Description", textEditingController: itemDescriptionController, 
                          textInputType: TextInputType.multiline, maxLines: 5),
                        Gap(20.h), // Increased spacing


                        // Price TextForm field
                        appInput(placeholder: "Price", textEditingController: priceController, 
                          textInputType: TextInputType.number, errorLengthMsg: AppText.priceIsEmptyError
                        ),
                        Gap(20.h), 


                        // // CompanyTIN TextForm field
                        // TextFormField(
                        //   enabled: false,
                        //   controller: companyTINController,
                        //   decoration: InputDecoration(
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(10)
                        //     ),
                        //     contentPadding: const EdgeInsets.only(left: 20),
                        //     labelText: "Company TIN"
                        //   ),
                        // ),
                        // const SizedBox(height: 20),


                        // Item Category Dropdown
                        appDropdown(selectedValue: selectedItemCategory, items: itemCategoryOptions),
                        Gap(20.h), 


                        // Checkboxes in a Column instead of Row to prevent overflow
                        Column(
                          children: [
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero, // Remove default padding
                              title: appParagraph(title: "isTaxable", color: Colors.black),
                              value: isTaxable, 
                              onChanged: (bool? value) => {
                                setState(() {
                                  isTaxable = value ?? !isTaxable;
                                })
                              }
                            ),
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero, // Remove default padding
                              title: appParagraph(title: "isTaxInclusive", color: Colors.black),
                              value: isTaxInclusive, 
                              onChanged: (bool? value) => {
                                setState(() {
                                  isTaxInclusive = value ?? !isTaxInclusive;
                                })
                              }
                            ),
                          ],
                        ),
                        Gap(20.h), // Increased spacing


                        // TourismCST Dropdown
                        appDropdown(selectedValue: selectedTourismCSTOption, items: tourismCSTOptions),
                        Gap(20.h), 

                       // Increased spacing
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange
                            ),
                            onPressed: () {
                              addItems();
                            }, 
                            child: appParagraph(title: AppText.addItemButton, color: AppColors.white)
                          ),
                        ),
                        Gap(50.h), // Added bottom padding
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }


  // Function to add items
  Future<void> addItems() async {
    if(_formKey.currentState!.validate()) {
      try {
        // Create the item object
        final response = await ItemService.addItem(
          itemCode: itemCodeController.text, 
          itemName: itemNameController.text,
          itemDescription: itemDescriptionController.text.isEmpty ? null : itemDescriptionController.text,
          price: double.parse(priceController.text),
          itemCategory: selectedItemCategory ?? "RegularVAT",
          isTaxable: isTaxable,
          isTaxInclusive: isTaxInclusive,
          tourismCSTOption: selectedTourismCSTOption ?? "None",
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
            selectedItemCategory = "RegularVAT";
            selectedTourismCSTOption = "None";
            isTaxable = false;
            isTaxInclusive = true;
          });

          // Try to get item data from response
          final itemData = response['data'] ?? response['item'];
          
          if (itemData != null) {
            print('About to show modal with data: $itemData');
            // Show modal with created item details
            await showItemCreatedModal(itemData);
          } else {
            print('No item data found in response');
            // Fallback to SnackBar if no item data
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response['message'] ?? 'Item created successfully')),
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
    // print("Item added");
  }


  // Add this method to your widget class
  Future<void> showItemCreatedModal(Map<String, dynamic> itemData) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 10),
              Text('Item Created Successfully'),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildDetailRow('Item Code', itemData['item_code']?.toString() ?? 'N/A'),
                _buildDetailRow('Item Name', itemData['item_name']?.toString() ?? 'N/A'),
                if (itemData['item_description'] != null)
                  _buildDetailRow('Description', itemData['item_description'].toString()),
                _buildDetailRow('Price', '\$${itemData['price']?.toString() ?? '0.00'}'),
                _buildDetailRow('Category', itemData['item_category']?.toString() ?? 'N/A'),
                _buildDetailRow('Taxable', itemData['is_taxable'] == true ? 'Yes' : 'No'),
                _buildDetailRow('Tax Inclusive', itemData['is_tax_inclusive'] == true ? 'Yes' : 'No'),
                _buildDetailRow('Tourism CST', itemData['tourism_cst_option']?.toString() ?? 'None'),
                if (itemData['company_tin'] != null)
                  _buildDetailRow('Company TIN', itemData['company_tin'].toString()),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Add Another Item'),
              onPressed: () {
                Navigator.of(context).pop();
                // Form is already cleared, so user can immediately add another item
              },
            ),
          ],
        );
      },
    );
  }


  // Helper method to build detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
