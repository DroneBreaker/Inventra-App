import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool _darkMode = false;
  String _selectedItem = 'Dashboard';

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.dashboard, 'label': 'Home', 'route': '/intro'},
    {'icon': Icons.description, 'label': 'Invoices', 'route': '/invoices'},
    {'icon': Icons.people, 'label': 'Customers', 'route': '/customers'},
    {'icon': Icons.assignment, 'label': 'Incomes', 'route': '/income'},
    {'icon': Icons.money, 'label': 'Expenses', 'route': '/expenses'},
    {'icon': Icons.inventory, 'label': 'Items/Services', 'route': '/items'},
    {'icon': Icons.bar_chart, 'label': 'Reports', 'route': '/reports'},
    {'icon': Icons.people, 'label': 'User Management', 'route': '/users'},
    // {'icon': Icons.settings, 'label': 'Settings'},
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _darkMode 
          ? ThemeData.dark().copyWith(
              primaryColor: Colors.blueAccent,
              cardColor: Colors.grey[850],
            )
          : ThemeData.light().copyWith(
              primaryColor: Colors.blueAccent,
              cardColor: Colors.white,
            ),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(),
              
              // Stats Bar
              _buildStatsBar(),
              
              // Search (optional)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              
              // Menu Items
              Expanded(
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
              
              // Footer
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Inventra',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 48), // Balance the header
        ],
      ),
    );
  }

  Widget _buildStatsBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '3 Unpaid Invoices',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 8),
          Text('•'),
          SizedBox(width: 8),
          Text(
            '\$1,800 Pending',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, String route) {
    bool isSelected = _selectedItem == label;
    return ListTile(
      leading: Icon(icon, color: isSelected 
          ? Theme.of(context).primaryColor 
          : Theme.of(context).iconTheme.color),
      title: Text(label),
      trailing: isSelected 
          ? Container(
              width: 4,
              height: 24,
              color: Theme.of(context).primaryColor,
            )
          : null,
      onTap: () {
        setState(() => _selectedItem = label);
        Navigator.of(context).pushReplacementNamed(route);
        // Add navigation logic here
      },
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {},
          ),
          Switch(
            value: _darkMode,
            onChanged: (value) => setState(() => _darkMode = value),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}