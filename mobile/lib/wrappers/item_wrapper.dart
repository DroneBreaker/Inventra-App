// item_wrapper.dart
import 'package:flutter/material.dart';
import 'package:inventra/screens/items/all_items.dart';
import 'package:inventra/screens/items/item.dart';

class ItemWrapper extends StatefulWidget {
  const ItemWrapper({super.key});

  @override
  State<ItemWrapper> createState() => _ItemWrapperState();
}

class _ItemWrapperState extends State<ItemWrapper> {
  int _currentItemTab = 0;
  
  final List<Widget> itemPages = const [
    ItemsPage(),
    AllItemsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
            children: [
              IndexedStack(
                index: _currentItemTab,
                children: itemPages,
              ),
              Positioned(
                top: 8,
                left: 10,
                child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black, size: 40,),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
            ],
          ),
        ),
      bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentItemTab,
                onTap: (index) => setState(() => _currentItemTab = index),
                unselectedItemColor: Colors.grey[400],
                selectedItemColor: Colors.amber[800],
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
    );
  }
}








// class ItemWrapper extends StatefulWidget {
//   const ItemWrapper({super.key});

//   @override
//   State<ItemWrapper> createState() => _ItemWrapperState();
// }

// class _ItemWrapperState extends State<ItemWrapper> {
//   int _currentItemTab = 0;
  
//   final List<Widget> _itemPages = const [
//     ItemsPage(),
//     AllItemsPage(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             // Scrollable content area
//             SingleChildScrollView(
//               child: SizedBox(
//                 height: MediaQuery.of(context).size.height -
//                     MediaQuery.of(context).padding.top -
//                     kBottomNavigationBarHeight,
//                 child: IndexedStack(
//                   index: _currentItemTab,
//                   children: _itemPages,
//                 ),
//               ),
//             ),
//             // Back button overlay
//             Positioned(
//               top: 8,
//               left: 5,
//               child: IconButton(
//                 icon: const Icon(
//                   Icons.arrow_back,
//                   color: Colors.black,
//                   size: 5, // Reduced from 50 for better proportions
//                 ),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: SizedBox(
//         height: kBottomNavigationBarHeight, // Standard height
//         child: BottomNavigationBar(
//           currentIndex: _currentItemTab,
//           onTap: (index) => setState(() => _currentItemTab = index),
//           unselectedItemColor: Colors.grey[400],
//           selectedItemColor: Colors.amber[800],
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.create),
//               label: 'Create Item',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.list_alt),
//               label: 'All Items',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }