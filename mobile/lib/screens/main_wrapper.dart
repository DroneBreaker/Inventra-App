import 'package:flutter/material.dart';
import 'package:inventra/screens/home.dart';
import 'package:inventra/screens/invoices.dart';
import 'package:inventra/screens/menu.dart';
import 'package:inventra/screens/reports.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int currentPage = 0;
  final List<Widget> pages = const [
    HomePage(),
    InvoicePage(),
    ReportPage(),
    MenuPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[currentPage],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPage,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.create), label: 'Invoices'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Reports'),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
          ],
          unselectedItemColor: Colors.grey[400],
          type: BottomNavigationBarType.fixed,
          iconSize: 30,
          onTap: (value) {
            setState(() {
              currentPage = value;
            });
          },
        ),
    );
  }
}