import 'package:flutter/material.dart';
import 'package:inventra/screens/items/all_items.dart';
import 'package:inventra/widgets/app_text.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Center(
                child: AppText(title: "HELLO FUCKERS"),
              )
            ],
          ),
        ),
      ),
    );
  }
}