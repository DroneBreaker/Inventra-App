import 'package:flutter/material.dart';

class IncomeWrapper extends StatefulWidget {
  const IncomeWrapper({super.key});

  @override
  State<IncomeWrapper> createState() => _IncomeWrapperState();
}

class _IncomeWrapperState extends State<IncomeWrapper> {
  int currentIncomePage = 0;

  List<Widget> incomePages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Stack(
        children: [
          IndexedStack(
            index: currentIncomePage,
            children: incomePages,
          ),
        ],
      )),

    );
  }
}