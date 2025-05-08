import 'package:flutter/material.dart';
import 'package:inventra/constants/app_titles.dart';
import 'package:inventra/screens/items/all_items.dart';
import 'package:inventra/widgets/app_text.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  final TextEditingController itemCodeController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemDescriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController companyTINController = TextEditingController();

  // ITEM CATERGORY
  final selectedItemCategory = "Regular VAT";
  final itemCategoryOptions = [
    "Regular VAT",
    "Rent",
    "Exempt"
  ];
  
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Center(
                        child: AppText(title: "HELLO ITEM FUCKERS"),
                      ),
                      SizedBox(height: 15,),
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
                        },
                      ),
                      SizedBox(height: 15,),
                      // Item Name TextForm  field
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
                        },
                      ),
                      SizedBox(height: 15,),
                      // Item Desscription TextForm field
                      TextFormField(
                        controller: itemDescriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          contentPadding: const EdgeInsets.only(left: 20),
                          labelText: "Item Description"
                        ),
                      ),
                      SizedBox(height: 15,),
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
                        },
                      ),
                      SizedBox(height: 15,),
                      // CompanyTIN TextForm field
                      TextFormField(
                        enabled: false,
                        controller: companyTINController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          contentPadding: const EdgeInsets.only(left: 20),
                          labelText: "Company TIN"
                        ),
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
                      SizedBox(height: 15,),
                      // Remarks TextForm field
                      TextFormField(
                        controller: itemDescriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          contentPadding: const EdgeInsets.only(left: 20),
                          labelText: "Remarks"
                        ),
                      ),
                      SizedBox(height: 15,),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey
                          ),
                          onPressed: () {
                            // addItems();
                          }, 
                          child: AppText(title: AppTitle.addItemButton, colors: Colors.black,)
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
    );
  }
}