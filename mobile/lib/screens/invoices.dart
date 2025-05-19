import 'package:flutter/material.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Positioned(
            //   top: 10,
            //   left: 8,
            //   child: IconButton(
            //     onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back, size: 40,),)
            // ),
            Center(child: Text("Hello INVOICE"),),
          ]
        ),
      )
    );
  }
}