import 'package:flutter/material.dart';
import 'package:inventra/constants/app_titles.dart';
import 'package:inventra/widgets/app_text.dart';

Widget transaction() {
  final transactionTypes = [
    {"label": "All Invoices"},
    {"label": "All Invoices"},
    {"label": "All Invoices"},
  ];

  return StatefulBuilder(builder: (context, setState) {
    return Column(
      children: [
        AppText(title: AppTitle.recentTransaction),
        GridView.builder(
              itemCount: transactionTypes.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3
                ), 
                itemBuilder: (context, index) {
                  final transactionType = transactionTypes[index];
                },
              ),
          ],
    );
  },);
}