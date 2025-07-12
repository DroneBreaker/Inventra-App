import 'package:flutter/material.dart';
import 'package:inventra/widgets/app_text.dart';

class AllItemsPage extends StatefulWidget {
  const AllItemsPage({super.key});

  @override
  State<AllItemsPage> createState() => _AllItemsPageState();
}

class _AllItemsPageState extends State<AllItemsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: appText(title: "ITEMS PAGE IS UNDER CONSTRUCTION", fontSize: 18,),
        ),
      ),
    );
  }
}