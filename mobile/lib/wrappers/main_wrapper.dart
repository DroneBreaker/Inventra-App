import 'package:flutter/material.dart';
import 'package:inventra/screens/create_invoice.dart';
import 'package:inventra/screens/home.dart';
import 'package:inventra/screens/invoices.dart';
import 'package:inventra/wrappers/item_wrapper.dart';
import 'package:inventra/screens/items/item.dart';
import 'package:inventra/screens/menu.dart';
import 'package:inventra/screens/reports.dart';


class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int currentPage = 0;

  final List<Widget> pages = [
    const HomePage(),
    const InvoicePage(),
    const ReportPage(),
    const MenuPage(),
    const ItemWrapper()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPage,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentPage,
              unselectedItemColor: Colors.grey[400],
              selectedItemColor: Colors.amber[800],
              onTap: (index) => setState(() => currentPage = index),
              iconSize: 30,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Invoices'),
                BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Reports'),
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
              ],
            ),
    );
  }
}


// class MainWrapper extends StatefulWidget {
//   const MainWrapper({super.key});

//   @override
//   State<MainWrapper> createState() => _MainWrapperState();
// }



// class _MainWrapperState extends State<MainWrapper> {
//   int currentPage = 0;
//   late List<Widget> pages = const [
//     HomePage(),
//     InvoicePage(),
//     ReportPage(),
//     MenuPage()
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: pages[currentPage],
//         bottomNavigationBar: SizedBox(
//           height: 150,
//           child: BottomNavigationBar(
//             currentIndex: currentPage,
//             items: const <BottomNavigationBarItem>[
//               BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//               BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Invoices'),
//               BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Reports'),
//               BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
//             ],
//             unselectedItemColor: Colors.grey[400],
//             selectedItemColor: Colors.amber[800],
//             type: BottomNavigationBarType.fixed,
//             iconSize: 35,
//             onTap: (index) {
//               setState(() {
//                 currentPage = index;
//               });
//             },
//           ),
//         ),
//     );
//   }
// }
