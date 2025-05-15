import 'package:flutter/material.dart';
import 'package:inventra/screens/clients/create_customer.dart';
import 'package:inventra/screens/clients/customer.dart';
import 'package:inventra/screens/clients/export.dart';

class CustomerWrapper extends StatefulWidget {
  const CustomerWrapper({super.key});

  @override
  State<CustomerWrapper> createState() => _CustomerWrapperState();
}

class _CustomerWrapperState extends State<CustomerWrapper> {
  int currentCustomerPage = 0;

  final List<Widget> customerPages = [
    CreateCustomerPage(),
    CustomerPage(),
    ExportPage()
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(
              index: currentCustomerPage,
              children: customerPages,
            ),
            Positioned(
              top: 8,
              left: 10,
              child: IconButton(
                onPressed: () => Navigator.pop(context), 
                icon: Icon(Icons.arrow_back, color: Colors.black, size: 40,)
              )
            )
          ],
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentCustomerPage,
              backgroundColor: Colors.grey[700],
          unselectedItemColor: Colors.grey[400],
          selectedItemColor: Colors.amber[800],
          onTap: (index) {
            setState(() {
              currentCustomerPage = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          iconSize: 30,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.add_business), label: "Create Clients"),
            BottomNavigationBarItem(icon: Icon(Icons.business), label: "Customer"),
            BottomNavigationBarItem(icon: Icon(Icons.business_rounded), label: "Supplier"),
            BottomNavigationBarItem(icon: Icon(Icons.import_export), label: "Export"),
          ]
        ),
    );
  }
}