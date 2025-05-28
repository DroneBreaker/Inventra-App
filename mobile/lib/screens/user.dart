import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;


class UserManagementPage extends StatefulWidget {
  const UserManagementPage({Key? key}) : super(key: key);

  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  // Temporary list for UI demonstration (in real app, fetch from Rust backend)
  List<Map<String, dynamic>> users = [
    {'id': '1', 'name': 'John Doe', 'email': 'john@example.com', 'role': 'Admin', 'lastLogin': '2023-05-15'},
    {'id': '2', 'name': 'Jane Smith', 'email': 'jane@example.com', 'role': 'Staff', 'lastLogin': '2023-05-10'},
  ];

  // Form controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController companyTINController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  // Role options
  String _selectedRole = 'Staff';
  final roleOptions = [
    "Staff",
    "Admin"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchUsers,
            tooltip: 'Refresh Users',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dashboard Summary Cards
            _buildDashboardCards(),
            const SizedBox(height: 20),
            
            // Add User Section
            _buildAddUserForm(),
            const SizedBox(height: 20),
            
            // Users List
            Expanded(
              child: _buildUsersList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCards() {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Users',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  Text(
                    users.length.toString(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active Today',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  Text(
                    users.where((u) => u['lastLogin'] == '2023-05-15').length.toString(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }


// Add user form
  Widget _buildAddUserForm() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New User',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),


            // Last NAme TextForm field
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),


            // Email Textform field
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),

            // Password Textformfield
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              items: roleOptions
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addUser,
                child: const Text('Create User'),
              ),
            ),
          ],
        ),
      ),
    );
  }


// User list
  Widget _buildUsersList() {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'User List',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(user['name'][0]),
                  ),
                  title: Text(user['name']),
                  subtitle: Text(user['email']),
                  trailing: Chip(
                    label: Text(user['role']),
                    backgroundColor: user['role'] == 'Admin'
                        ? Colors.blue[100]
                        : Colors.grey[200],
                  ),
                  onTap: () {
                    _showUserDetails(user);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _fetchUsers() async {
    // TODO: Call Rust backend API to fetch users
    // Example:
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/user_account'));
    setState(() {
      users = jsonDecode(response.body);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshing users...')),
    );
  }

  void _addUser() async {
    if (usernameController.text.isEmpty ||
        companyTINController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // TODO: Call Rust backend API to create user
    // Example:
    // final response = await http.post(
    //   Uri.parse('http://your-rust-backend/api/users'),
    //   body: jsonEncode({
    //     'name': _nameController.text,
    //     'email': _emailController.text,
    //     'password': _passwordController.text,
    //     'role': _selectedRole,
    //   }),
    // );

    // For demo, add to local list
    setState(() {
      users.add({
        'id': (users.length + 1).toString(),
        'name': usernameController.text,
        'email': companyTINController.text,
        'role': _selectedRole,
        'lastLogin': 'Never',
      });
    });

    // Clear form
    usernameController.clear();
    companyTINController.clear();
    passwordController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User created successfully')),
    );
  }

  void _showUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${user['email']}'),
            const SizedBox(height: 8),
            Text('Role: ${user['role']}'),
            const SizedBox(height: 8),
            Text('Last Login: ${user['lastLogin']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    companyTINController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}