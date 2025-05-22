// import 'package:flutter/material.dart';
// import 'package:inventra/constants/app_titles.dart';
// import 'package:inventra/widgets/app_text.dart';

import 'package:flutter/material.dart';
import 'package:inventra/constants/app_titles.dart';
import 'package:inventra/services/item_service.dart';
import 'package:inventra/widgets/app_text.dart';

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
    "Regular VAT",
    "Rent",
    "Exempt"
  ];
  String selectedItemCategory = "Regular VAT";

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
                          child: AppText(title: "HELLO ITEM FUCKERS"),
                        ),
                        const SizedBox(height: 25), 
                        
                        // ItemCode TextForm field
                        TextFormField(
                          controller: itemCodeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            contentPadding: const EdgeInsets.only(left: 20),
                            labelText: "Item Code"
                          ),
                          validator: (value) {
                            if(value == null || value.isEmpty) {
                              return AppTitle.noItemCodeError;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20), 


                        // Item Name TextForm field
                        TextFormField(
                          controller: itemNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            contentPadding: const EdgeInsets.only(left: 20),
                            labelText: "Item Name"
                          ),
                          validator: (value) {
                            if(value == null || value.isEmpty) {
                              return AppTitle.invalidItemNameError;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20), 


                        // Item Description TextForm field
                        TextFormField(
                          controller: itemDescriptionController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            contentPadding: const EdgeInsets.only(left: 20, top: 30),
                            labelText: "Item Description"
                          ),
                        ),
                        const SizedBox(height: 20), // Increased spacing


                        // Price TextForm field
                        TextFormField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            contentPadding: const EdgeInsets.only(left: 20),
                            labelText: "Price"
                          ),
                          validator: (value) {
                            if(value == null || value.isEmpty) {
                              return AppTitle.priceIsEmptyError;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20), 


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
                        DropdownButtonFormField(
                          value: selectedItemCategory,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: 'Item Category',
                          ),
                          items: itemCategoryOptions.map((String option) {
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
                        const SizedBox(height: 20), 


                        // Checkboxes in a Column instead of Row to prevent overflow
                        Column(
                          children: [
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero, // Remove default padding
                              title: AppText(title: "isTaxable", colors: Colors.black),
                              value: isTaxable, 
                              onChanged: (bool? value) => {
                                setState(() {
                                  isTaxable = value ?? !isTaxable;
                                })
                              }
                            ),
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero, // Remove default padding
                              title: AppText(title: "isTaxInclusive", colors: Colors.black),
                              value: isTaxInclusive, 
                              onChanged: (bool? value) => {
                                setState(() {
                                  isTaxInclusive = value ?? !isTaxInclusive;
                                })
                              }
                            ),
                          ],
                        ),
                        const SizedBox(height: 20), // Increased spacing


                        // TourismCST Dropdown
                        DropdownButtonFormField(
                          value: selectedTourismCSTOption,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: 'Item Category',
                          ),
                          items: tourismCSTOptions.map((String option) {
                            return DropdownMenuItem(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if(newValue != null) {
                              setState(() {
                                selectedTourismCSTOption = newValue;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 20), 

                       // Increased spacing
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey
                            ),
                            onPressed: () {
                              addItems();
                            }, 
                            child: AppText(title: AppTitle.addItemButton, colors: Colors.black)
                          ),
                        ),
                        const SizedBox(height: 30), // Added bottom padding
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
          companyTIN: companyTINController.text,
          itemCategory: selectedItemCategory,
          isTaxable: isTaxable,
          isTaxInclusive: isTaxInclusive,
          tourismCSTOption: selectedTourismCSTOption,
        );

        // Hide loading indicator
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (response['success'] == true) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
          
          // Clear the form
          _formKey.currentState!.reset();
          setState(() {
            selectedItemCategory = "Regular VAT";
            isTaxable = false;
            isTaxInclusive = true;
          });
        } else {
          // Error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: AppText(title: 'Error: $e')),
          );
        }
      }
    }
    // print("Item added");
  }
}




























// class ItemsPage extends StatefulWidget {
//   const ItemsPage({super.key});

//   @override
//   State<ItemsPage> createState() => _ItemsPageState();
// }

// class _ItemsPageState extends State<ItemsPage> {
//   final TextEditingController itemCodeController = TextEditingController();
//   final TextEditingController itemNameController = TextEditingController();
//   final TextEditingController itemDescriptionController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   final TextEditingController companyTINController = TextEditingController();

//   // ITEM CATERGORY
//   final selectedItemCategory = "Regular VAT";
//   final itemCategoryOptions = [
//     "Regular VAT",
//     "Rent",
//     "Exempt"
//   ];

//   // TAX INCLUSIVE
//   bool isTaxable = false;
//   bool isTaxInclusive = true;
  
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.only(top: 60.0),
//               child: SizedBox(
//                 height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 20.0, right: 20),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         Center(
//                           child: AppText(title: "HELLO ITEM FUCKERS"),
//                         ),
//                         SizedBox(height: 15,),
//                         TextFormField(
//                           controller: itemCodeController,
//                           keyboardType: TextInputType.number,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10)
//                             ),
//                             contentPadding: const EdgeInsets.only(left: 20),
//                             labelText: "Item Code"
//                           ),
//                           validator: (value) {
//                             if(value == null || value.isEmpty) {
//                               return AppTitle.noItemCodeError;
//                             }
//                           },
//                         ),
//                         SizedBox(height: 15,),
//                         // Item Name TextForm  field
//                         TextFormField(
//                           controller: itemNameController,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10)
//                             ),
//                             contentPadding: const EdgeInsets.only(left: 20),
//                             labelText: "Item Name"
//                           ),
//                           validator: (value) {
//                             if(value == null || value.isEmpty) {
//                               return AppTitle.invalidItemNameError;
//                             }
//                           },
//                         ),
//                         SizedBox(height: 15,),
//                         // Item Desscription TextForm field
//                         TextFormField(
//                           controller: itemDescriptionController,
//                           keyboardType: TextInputType.multiline,
//                           maxLines: 5,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10)
//                             ),
//                             contentPadding: const EdgeInsets.only(left: 20),
//                             labelText: "Item Description"
//                           ),
//                         ),
//                         SizedBox(height: 15,),
//                         // Price TextForm field
//                         TextFormField(
//                           controller: priceController,
//                           keyboardType: TextInputType.number,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10)
//                             ),
//                             contentPadding: const EdgeInsets.only(left: 20),
//                             labelText: "Price"
//                           ),
//                           validator: (value) {
//                             if(value == null || value.isEmpty) {
//                               return AppTitle.priceIsEmptyError;
//                             }
//                           },
//                         ),
//                         SizedBox(height: 15,),
//                         // CompanyTIN TextForm field
//                         TextFormField(
//                           enabled: false,
//                           controller: companyTINController,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10)
//                             ),
//                             contentPadding: const EdgeInsets.only(left: 20),
//                             labelText: "Company TIN"
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         // Item Category Dropdown
//                         DropdownButtonFormField<String>(
//                           value: selectedItemCategory,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             labelText: 'Item Category',
//                           ),
//                           items: itemCategoryOptions.map((String option) {
//                             return DropdownMenuItem<String>(
//                               value: option,
//                               child: Text(option),
//                             );
//                           }).toList(),
//                           onChanged: (_) {},
//                         ),
//                         SizedBox(height: 15,),
//                         Row(
//                           children: [
//                             CheckboxListTile(
//                               title: AppText(title: "isTaxable", colors: Colors.black,),
//                               value: isTaxable, 
//                               onChanged: (bool? value) => {
//                                 setState(() {
//                                   isTaxable = value ?? !isTaxable;
//                                 })
//                               }
//                             ),
//                             CheckboxListTile(
//                               title: AppText(title: "isTaxInclusive", colors: Colors.black,),
//                               value: isTaxInclusive, 
//                               onChanged: (bool? value) => {
//                                 setState(() {
//                                   isTaxInclusive = value ?? !isTaxInclusive;
//                                 })
//                               }
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 15,),
//                         // Remarks TextForm field
//                         TextFormField(
//                           controller: itemDescriptionController,
//                           keyboardType: TextInputType.multiline,
//                           maxLines: 4,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10)
//                             ),
//                             contentPadding: const EdgeInsets.only(left: 20),
//                             labelText: "Remarks"
//                           ),
//                         ),
//                         SizedBox(height: 15,),
//                         SizedBox(
//                           width: double.infinity,
//                           height: 50,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.grey
//                             ),
//                             onPressed: () {
//                               // addItems();
//                             }, 
//                             child: AppText(title: AppTitle.addItemButton, colors: Colors.black,)
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//     );
//   }
// }