import 'package:flutter/material.dart';
import 'package:inventra/widgets/app_text.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child: AppText(title: "CUSTOMERS PAGE"),
    ),);
  }
}