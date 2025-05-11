import 'package:flutter/material.dart';
import 'package:inventra/widgets/app_text.dart';

class AdvanceIncome extends StatefulWidget {
  const AdvanceIncome({super.key});

  @override
  State<AdvanceIncome> createState() => _AdvanceIncomeState();
}

class _AdvanceIncomeState extends State<AdvanceIncome> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: AppText(title: "ADVANCE INVOICE HERE..."),
      ),
    );
  }
}