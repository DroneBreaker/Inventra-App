import 'package:flutter/material.dart';
import 'package:inventra/widgets/app_text.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({super.key});

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AppText(title: "SUPPLIER PAGE UNDER CONSTRUCTION.."),
        ),
      ),
    );
  }
}