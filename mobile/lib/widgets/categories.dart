import 'package:flutter/material.dart';
import 'package:inventra/constants/app_colors.dart';
import 'package:inventra/constants/routes.dart';
import 'package:inventra/widgets/app_text.dart';

Widget buildCategories() {
  final categories = [
    {'icon': Icons.create, 'label': "Create Invoice", 'route': RouteNames.createInvoice, 'color': AppColors.success},
    {'icon': Icons.attach_money, 'label': "Advance Inv.", 'route': RouteNames.advanceInvoice, 'color': Colors.yellow},
    {'icon': Icons.people, 'label': "Customers", 'route': RouteNames.customers, 'color': AppColors.success},
    {'icon': Icons.shopping_basket, 'label': "Items", 'route': RouteNames.items, 'color': Colors.orange},
    {'icon': Icons.add_shopping_cart, 'label': "Expenses", 'route': RouteNames.expenses, 'color': Colors.red},
    {'icon': Icons.analytics, 'label': "Income", 'route': RouteNames.income, 'color': Colors.green},
  ];
  

  return StatefulBuilder(builder: (context, setState) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Disable scrolling
      padding: const EdgeInsets.only(bottom: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of columns
        childAspectRatio: 0.9, // Width/height ratio
        mainAxisSpacing: 5, // Vertical spacing
        crossAxisSpacing: 2, // Horizontal spacing
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryItem(
          context,
          icon: category['icon'] as IconData,
          label: category['label'] as String,
          route: category['route'] as String,
          color: category['color'] as Color,
        );
      },
    );
  });
}

Widget _buildCategoryItem(
  BuildContext context, {
  required IconData icon,
  required String label,
  required String route,
  required Color color,
}) {
  return InkWell(
    onTap: () => Navigator.of(context).pushNamed(route),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: AppColors.grey400.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color ?? Color.fromRGBO(56, 255, 67, 0.6), size: 27,),
        ),
        const SizedBox(height: 6),
        Center(child: AppText(title: label)),
      ],
    ),
  );
}