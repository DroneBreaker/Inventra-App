import 'package:flutter/material.dart';
import 'package:inventra/constants/app_titles.dart';
import 'package:inventra/widgets/app_text.dart';

Widget transaction() {
  final List<Map<String, String>> transactionTypes = [
    {"label": "All Invoices"},
    {"label": "Expenses"},
    {"label": "Income"},
  ];

  return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: AppText(title: AppTitle.recentTransaction, fontSize: 22, fontWeight: FontWeight.w700,),
        ),

        // Tabs 
        DefaultTabController(
          length: transactionTypes.length, 
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(
                tabs: [
                  for(var type in transactionTypes)
                  Tab(text: type['label'],)
                ]
              ),

              SizedBox(
                height: 100,
                child: TabBarView(
                  children: [
                    for(var type in transactionTypes)
                    Center(child: AppText(title: "$type['label] content"),)
                  ]
                ),
              )
            ],
          )
        )
        // GridView.builder(
        //   shrinkWrap: true,
        //   itemCount: transactionTypes.length,
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 3
        //     ), 
        //     itemBuilder: (context, index) {
        //       final transactionType = transactionTypes[index];
        //       // return Row(
        //       //   children: [
        //       //    Tab(child: ,),
        //       //    Tab(),
        //       //    Tab()
        //       //   ],
        //       // );
        //     },
        //   ),
      ],
  );
}




// import 'package:flutter/material.dart';
// import 'package:inventra/constants/app_colors.dart';
// import 'package:inventra/widgets/app_text.dart';

// Widget buildCategories() {
//   final categories = [
//     {'icon': Icons.create, 'label': "Create Invoice", 'route': "/invoice", 'color': AppColors.success},
//     {'icon': Icons.attach_money, 'label': "Advance Invoice", 'route': "/advance-invoice", 'color': Colors.yellow},
//     {'icon': Icons.people, 'label': "Customers", 'route': "/customers", 'color': AppColors.success},
//     {'icon': Icons.shopping_basket, 'label': "Items", 'route': "/items", 'color': Colors.orange},
//     {'icon': Icons.add_shopping_cart, 'label': "Expenses", 'route': "/expenses", 'color': Colors.red},
//     {'icon': Icons.analytics, 'label': "Income", 'route': "/income", 'color': Colors.green},
//   ];

//   return StatefulBuilder(builder: (context, setState) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(), // Disable scrolling
//       padding: const EdgeInsets.all(8),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3, // Number of columns
//         childAspectRatio: 1, // Width/height ratio
//         // mainAxisSpacing: 5, // Vertical spacing
//         crossAxisSpacing: 4, // Horizontal spacing
//       ),
//       itemCount: categories.length,
//       itemBuilder: (context, index) {
//         final category = categories[index];
//         return _buildCategoryItem(
//           context,
//           icon: category['icon'] as IconData,
//           label: category['label'] as String,
//           route: category['route'] as String,
//           color: category['color'] as Color,
//         );
//       },
//     );
//   });
// }

// Widget _buildCategoryItem(
//   BuildContext context, {
//   required IconData icon,
//   required String label,
//   required String route,
//   required Color color,
// }) {
//   return GestureDetector(
//     onTap: () => Navigator.pushNamed(context, route),
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           height: 60,
//           width: 60,
//           decoration: BoxDecoration(
//             color: AppColors.grey400,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(icon, color: color ?? Color.fromRGBO(56, 255, 67, 0.6), size: 30,),
//         ),
//         const SizedBox(height: 8),
//         AppText(title: label),
//       ],
//     ),
//   );
// }