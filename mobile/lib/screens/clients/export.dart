import 'package:flutter/material.dart';
import 'package:inventra/widgets/titles.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({super.key});

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: appTitle(title: "EXPORT PAGE IS UNDER CONSTRUCTION"),
        ),
      ),
    );
  }
}