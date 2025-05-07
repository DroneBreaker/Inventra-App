import 'package:flutter/material.dart';
import 'package:inventra/screens/auth/register.dart';
import 'package:inventra/screens/auth/login.dart';
import 'package:inventra/screens/create_invoice.dart';
import 'package:inventra/screens/home.dart';
import 'package:inventra/screens/intro.dart';
import 'package:inventra/screens/invoices.dart';
import 'package:inventra/wrappers/item_wrapper.dart';
import 'package:inventra/screens/items/all_items.dart';
import 'package:inventra/screens/menu.dart';
import 'package:inventra/screens/reports.dart';

void main() {
  runApp(
    const MyApp()
    );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/invoices': (context) => const InvoicePage(),
        '/reports': (context) => ReportPage(),
        '/menu': (context) => MenuPage(),
        '/create-invoice': (context) => const CreateInvoice(),
        '/customers': (context) => const CreateInvoice(),
        '/items': (context) => const ItemWrapper(),
        '/all-items': (context) => const AllItemsPage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const IntroPage(),
    );
  }
}
