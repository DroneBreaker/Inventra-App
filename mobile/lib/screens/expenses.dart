import 'package:flutter/material.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 8,
              child: IconButton(
              onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, size: 40,))
            )
          ],
        )
      ),
    );
  }
}