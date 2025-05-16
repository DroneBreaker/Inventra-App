import 'package:flutter/material.dart';
import 'package:inventra/constants/routes.dart';
import 'package:inventra/widgets/app_text.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool _darkMode = false;
  String _selectedItem = 'Dashboard';

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.dashboard, 'label': 'Home', 'route': RouteNames.intro},
    {'icon': Icons.description, 'label': 'Invoices', 'route': RouteNames.invoices},
    {'icon': Icons.people, 'label': 'Customers', 'route': RouteNames.customers},
    {'icon': Icons.assignment, 'label': 'Incomes', 'route': RouteNames.income},
    {'icon': Icons.money, 'label': 'Expenses', 'route': RouteNames.expenses},
    {'icon': Icons.inventory, 'label': 'Items/Services', 'route': RouteNames.items},
    {'icon': Icons.bar_chart, 'label': 'Reports', 'route': RouteNames.reports},
    {'icon': Icons.people, 'label': 'User Management', 'route': RouteNames.users},
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _darkMode 
          ? ThemeData.dark().copyWith(
              primaryColor: Colors.blueAccent,
              cardColor: Colors.grey[850],
              dividerColor: Colors.grey[700], // Added for footer border
            )
          : ThemeData.light().copyWith(
              primaryColor: Colors.blueAccent,
              cardColor: Colors.white,
              dividerColor: Colors.grey[300],
            ),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // // Header Section (Improved alignment)
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Center(
              //             child: AppText(title: 
              //               'Inventra', fontSize: 20, fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //       ),
              //       SizedBox(width: 48, height: 48), // Balance the header
              //     ],
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: AppText(title: 
                    'Inventra', fontSize: 20, fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              

              // Stats Bar 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          '3 Unpaid Invoices',
                          style: TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('•'),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '\$1,800 Pending',
                          style: TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Search (Improved padding)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              
              // Menu Items (Added bottom padding)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListView.builder(
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      return _buildMenuItem(
                        _menuItems[index]['icon'],
                        _menuItems[index]['label'],
                        _menuItems[index]['route'] as String,
                      );
                    },
                  ),
                ),
              ),
              
              // Footer (Improved border visibility)
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.help_outline),
                      onPressed: () {},
                      tooltip: 'Help',
                    ),
                    Switch(
                      value: _darkMode,
                      onChanged: (value) => setState(() => _darkMode = value),
                    ),
                    IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () {},
                      tooltip: 'Logout',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, String route) {
    bool isSelected = _selectedItem == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        leading: Icon(
          icon,
          color: isSelected 
              ? Theme.of(context).primaryColor 
              : Theme.of(context).iconTheme.color,
          size: 24,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        trailing: isSelected 
            ? Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              )
            : null,
        onTap: () {
          setState(() => _selectedItem = label);
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}