import 'package:flutter/material.dart';
import 'package:inventra/widgets/titles.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child: appTitle(title: "CUSTOMERS PAGE"),
    ),);
  }
}