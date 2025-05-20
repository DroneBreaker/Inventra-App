import 'package:flutter/material.dart';

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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedRole = 'Staff';

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
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              items: ['Admin', 'Staff', 'Viewer']
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
    // final response = await http.get(Uri.parse('http://your-rust-backend/api/users'));
    // setState(() {
    //   users = jsonDecode(response.body);
    // });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshing users...')),
    );
  }

  void _addUser() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
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
        'name': _nameController.text,
        'email': _emailController.text,
        'role': _selectedRole,
        'lastLogin': 'Never',
      });
    });

    // Clear form
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}