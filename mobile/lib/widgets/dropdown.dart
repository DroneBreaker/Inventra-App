import 'package:flutter/material.dart';

class AppDropdown extends StatefulWidget {
  const AppDropdown({super.key});

  @override
  State<AppDropdown> createState() => _AppDropdownState();
}

class _AppDropdownState extends State<AppDropdown> {
  // FLAG OPTIONS
  String? selectedFlag;
  final List<String> flags = [
    "Invoice",
    "Purchase",
    "Refund",
    "Credit Note",
    "Debit Note",
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedFlag,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: 'Invoice Type',
      ),
      items:
          flags.map((String option) {
            return DropdownMenuItem<String>(value: option, child: Text(option));
          }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            selectedFlag = newValue;
          });
        }
      },
    );
  }
}

// // DropdownButtonFormField(
//                                 //   value: selectedInvoiceStatus,
//                                 //   decoration: InputDecoration(
//                                 //     border: OutlineInputBorder(
//                                 //       borderRadius: BorderRadius.circular(10),
//                                 //     ),
//                                 //     labelText: 'Invoice Status',
//                                 //   ),
//                                 //   items: invoiceStatus.map((String option) {
//                                 //     return DropdownMenuItem(
//                                 //       value: option,
//                                 //       child: Text(option),
//                                 //     );
//                                 //   }).toList(),
//                                 //   onChanged: (String? newValue) {
//                                 //     if(newValue != null) {
//                                 //       setState(() {
//                                 //         selectedItemCategory = newValue;
//                                 //       });
//                                 //     }
//                                 //   },
//                                 // ),
//                                 // Gap(20.h),
