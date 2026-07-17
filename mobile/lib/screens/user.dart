import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inventra/services/api_service.dart';
import 'package:inventra/widgets/titles.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({Key? key}) : super(key: key);

  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  // Real user data, fetched from the Gin backend
  List<Map<String, dynamic>> users = [];
  bool isLoading = true;
  String? errorMessage;

  // Form controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyIDController = TextEditingController();
  final TextEditingController companyTINController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Role options
  String selectedRole = "Staff";
  final roleOptions = ["Staff", "Admin"];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
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
                _buildUsersList(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCards() {
    final today = DateTime.now();

    bool isToday(dynamic lastLogin) {
      if (lastLogin == null) return false;
      final parsed = DateTime.tryParse(lastLogin.toString());
      if (parsed == null) return false;
      return parsed.year == today.year &&
          parsed.month == today.month &&
          parsed.day == today.day;
    }

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
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    users.length.toString(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    users
                        .where((u) => isToday(u['lastLogin']))
                        .length
                        .toString(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
      child: SingleChildScrollView(
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
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Last Name TextForm field
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Username TextForm field
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Email TextForm field
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Company Name TextForm field
            TextField(
              controller: companyNameController,
              decoration: InputDecoration(
                labelText: 'Company Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Company ID
            TextField(
              controller: companyIDController,
              decoration: InputDecoration(
                labelText: 'Company ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Company TIN TextForm field
            TextField(
              controller: companyTINController,
              decoration: InputDecoration(
                labelText: 'Company TIN',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Roles
            DropdownButtonFormField<String>(
              value: selectedRole,
              items:
                  roleOptions
                      .map(
                        (role) =>
                            DropdownMenuItem(value: role, child: Text(role)),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  selectedRole = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Password TextForm field
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),

            // Confirm Password TextForm field
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            // Button
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

  // Users
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
          SizedBox(
            height:
                MediaQuery.of(context).size.height * 0.4, // Constrain height
            child: _buildUsersListBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersListBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            TextButton(onPressed: _fetchUsers, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (users.isEmpty) {
      return const Center(child: Text('No users found'));
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(
              (user['first_name'] ?? '?').toString().isNotEmpty
                  ? user['first_name'].toString()[0]
                  : '?',
            ),
          ),
          title: Text('${user['first_name']} ${user['last_name']}'),
          subtitle: Text(user['email']?.toString() ?? ''),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Chip(
                label: Text(user['role']?.toString() ?? ''),
                backgroundColor:
                    user['role'] == 'Admin'
                        ? Colors.blue[100]
                        : Colors.grey[200],
              ),
              // --------------------------------------------> DO LATER
              // IconButton(
              //   onPressed: () => _updateUser(user['id']),
              //   icon: Icon(Icons.update),
              //   tooltip: 'Update User',
              // ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed:
                    () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: appTitle(title: "Confirm Deletion"),
                          content: appParagraph(
                            title:
                                "Are you sure you want to delete ${user['first_name']} ${user['last_name']}?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close dialog
                                _deleteUser(
                                  user['id'].toString(),
                                ); // Proceed with deletion
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                tooltip: 'Delete User',
              ),
            ],
          ),
          onTap: () {
            _showUserDetails(user);
          },
        );
      },
    );
  }

  Future<void> _fetchUsers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await APIService.fetchUsers();

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        // Adjust the 'data' key below if your Gin handler wraps the list
        // differently, e.g. c.JSON(200, gin.H{"data": users}) vs a bare array.
        final List<dynamic> userList =
            decoded is List ? decoded : (decoded['data'] ?? []);

        setState(() {
          users = List<Map<String, dynamic>>.from(userList);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch users: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching users: $e';
        isLoading = false;
      });
    }
  }

  // Add user
  Future<void> _addUser() async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        companyNameController.text.isEmpty ||
        companyIDController.text.isEmpty ||
        companyTINController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    try {
      final response = await APIService.registerUser(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        username: usernameController.text,
        companyName: companyNameController.text,
        companyID: companyIDController.text,
        companyTIN: companyTINController.text,
        role: selectedRole,
        password: passwordController.text,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh users after adding
        await _fetchUsers();
        // Clear form
        firstNameController.clear();
        lastNameController.clear();
        usernameController.clear();
        emailController.clear();
        companyNameController.clear();
        companyIDController.clear();
        companyTINController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User created successfully')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create user: ${response.statusCode}'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating user: $e')));
      }
    }
  }

  // Delete User
  Future<void> _deleteUser(String id) async {
    try {
      final response = await APIService.deleteUser(id);
      if (response.statusCode == 200) {
        await _fetchUsers(); // Refresh users after deletion
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User deleted successfully')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete user: ${response.statusCode}'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting user: $e')));
      }
    }
  }

  // Update User
  Future<void> _updateUser(
    String id,
    Map<String, dynamic> updatedFields,
  ) async {
    try {
      final response = await APIService.updateUser(id, data: updatedFields);

      if (response.statusCode == 200) {
        await _fetchUsers(); // Refresh users after update
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User updated successfully')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update user: ${response.statusCode}'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating user: $e')));
      }
    }
  }

  void _showUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('${user['first_name']} ${user['last_name']}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${user['email']}'),
                const SizedBox(height: 8),
                Text('Username: ${user['username']}'),
                const SizedBox(height: 8),
                Text('Company: ${user['company_name']}'),
                const SizedBox(height: 8),
                Text('Company ID: ${user['company_id']}'),
                const SizedBox(height: 8),
                Text('Company TIN: ${user['company_tin']}'),
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
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    companyNameController.dispose();
    companyIDController.dispose();
    companyTINController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
