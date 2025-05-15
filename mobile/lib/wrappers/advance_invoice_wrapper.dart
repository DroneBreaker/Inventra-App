import 'package:flutter/material.dart';
import 'package:inventra/screens/advance_income/create_advance_income.dart';
import 'package:inventra/wrappers/advance_income.dart';

class AdvanceInvoiceWrapper extends StatefulWidget {
  const AdvanceInvoiceWrapper({super.key});

  @override
  State<AdvanceInvoiceWrapper> createState() => _AdvanceInvoiceWrapper();
}

class _AdvanceInvoiceWrapper extends State<AdvanceInvoiceWrapper> {
  int currentAdvanceIncomePage = 0;

  final List<Widget> advanceIncomePages = [
    CreateAdvanceIncome(),
    AdvanceIncome()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(
              index: currentAdvanceIncomePage,
              children: advanceIncomePages,
            ),
            Positioned(
              top: 8,
              left: 10,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                }, 
                icon: Icon(Icons.arrow_back, size: 40,)
              )
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentAdvanceIncomePage,
          backgroundColor: Colors.grey[700],
          unselectedItemColor: Colors.grey[400],
          selectedItemColor: Colors.amber[800],
          onTap: (index) {
            setState(() {
              currentAdvanceIncomePage = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          iconSize: 30,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.create_rounded), label: "Create Advance"),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Advance Income"),
            BottomNavigationBarItem(icon: Icon(Icons.analytics_sharp), label: "Applied Income"),
            // BottomNavigationBarItem(icon: Icon(Icons.import_export), label: "Export"),
          ]
        ),
    );
  }
}