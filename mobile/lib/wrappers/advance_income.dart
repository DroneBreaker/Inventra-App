import 'package:flutter/material.dart';
import 'package:inventra/widgets/titles.dart';

class AdvanceIncome extends StatefulWidget {
  const AdvanceIncome({super.key});

  @override
  State<AdvanceIncome> createState() => _AdvanceIncomeState();
}

class _AdvanceIncomeState extends State<AdvanceIncome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: appTitle(title: "ADVANCE INVOICE HERE..."),
      ),
    );
  }
}