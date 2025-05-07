// item_wrapper.dart
import 'package:flutter/material.dart';
import 'package:inventra/screens/items/all_items.dart';
import 'package:inventra/screens/items/item.dart';
import 'package:inventra/widgets/app_text.dart';

class ItemWrapper extends StatefulWidget {
  const ItemWrapper({super.key});

  @override
  State<ItemWrapper> createState() => _ItemWrapperState();
}

class _ItemWrapperState extends State<ItemWrapper> {
  int _currentItemTab = 0;
  
  final List<Widget> _itemPages = const [
    ItemsPage(),
    AllItemsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(title: 'Items Management', fontSize: 20,),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: IndexedStack(
        index: _currentItemTab,
        children: _itemPages,
      ),
      bottomNavigationBar: SizedBox(
        height: 150,
        child: BottomNavigationBar(
          currentIndex: _currentItemTab,
          onTap: (index) => setState(() => _currentItemTab = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.create),
              label: 'Create Item',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'All Items',
            ),
          ],
        ),
      ),
    );
  }
}