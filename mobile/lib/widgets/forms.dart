import 'package:flutter/material.dart';

Widget appInput({required String placeholder, TextInputType? textInputType, required TextEditingController 
  textEditingController, String? errorMsg, String? errorLengthMsg, Function(String)? onTap, int? maxLines,
  Icon? icon
}) {
  return TextFormField(
      controller: textEditingController,
      keyboardType: textInputType,
      maxLines: maxLines,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        contentPadding: EdgeInsets.only(left: 20,),
        prefixIcon: icon,
        hintText: placeholder,
      ),
      validator: (value) {
        if(value == null || value.isEmpty) {
          return errorMsg;
        }
        if(value.length < 6) {
          return errorLengthMsg; 
        }
        return null;
      },
      onChanged: onTap
  );
}






// Form(
//                                         child: TextFormField(
//                                             controller: invoiceTimeController,
//                                             keyboardType: TextInputType.datetime,
//                                             decoration: InputDecoration(
//                                               border: OutlineInputBorder(
//                                                 borderRadius: BorderRadius.circular(10)
//                                               ),
//                                               contentPadding: EdgeInsets.only(top: 40, left: 20),
//                                               hintText: "Invoice Time"
//                                             ),
//                                             onChanged: (value) {
//                                               print('Invoice Time: $value');
//                                             },
//                                           ),







Widget appDropdown({required String selectedValue, required List<String> items}) {
  return DropdownButtonFormField(
    value: selectedValue,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      labelText: 'Invoice Status',
    ),
    items: items.map((String option) {
      return DropdownMenuItem(
        value: option,
        child: Text(option),
      );
    }).toList(),
    onChanged: (String? newValue) {
      if(newValue != null) {
        setState(() {
          selectedValue = newValue;
        });
      }
    },
  );
}

void setState(Null Function() param0) {
}




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