import 'package:flutter/material.dart';
import 'package:inventra/screens/home.dart';
import 'package:inventra/screens/invoices.dart';
import 'package:inventra/screens/menu.dart';
import 'package:inventra/screens/reports.dart';

int currentPage = 0;
const List<Widget> pages = [
  HomePage(),
  InvoicePage(),
  ReportPage(),
  MenuPage()
];

Widget bottomNavigation() {
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      return BottomNavigationBar(
      currentIndex: currentPage,
      items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Invoices'),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
      ],
      selectedItemColor: Colors.amber[800],
      type: BottomNavigationBarType.fixed,
      iconSize: 30,
      onTap: (value) {
        setState(() {
          currentPage = value;
        });
      },
    );
    }
  );
}