import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Directory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<UserBloc>().add(FetchUsersEvent()),
          ),
        ],
      ),
      body: BlocBuilder<UserBloc,UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 40, color: Colors.redAccent),
                  const SizedBox(height: 10),
                  Text('Error: ${state.message}'),
                ],
              ),
            );
          }

          if (state is UserLoaded) {
            final users = state.users;
            if (users.isEmpty) {
              return const Center(child: Text('No users found. Press + to add.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return Dismissible(
                  key: ValueKey(user.id),
                  background: Container(
                    color: Colors.redAccent.withOpacity(0.8),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    context.read<UserBloc>().add(DeleteUserEvent(user.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User deleted')),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: user.avatar.isNotEmpty ? NetworkImage(user.avatar) : null,
                        child: user.avatar.isEmpty ? const Icon(Icons.person) : null,
                      ),
                      title: Text(
                        '${user.first_Name} ${user.last_Name}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(user.email),
                      trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary),
                      onTap: () => _showActionMenu(context, user),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Welcome! Press + to load users.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddUserDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

/* Action Menu for Edit/Delete */
 
void _showActionMenu(BuildContext context, dynamic user) {
  showDialog(
    context: context,
    builder: (context) => Dialog(  
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 300, 
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
                child: Text(
                  'Manage User', 
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey),
                ),
              ),

              /* Edit */ 
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blueAccent),
                title: const Text('Edit User'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditDialog(context, user);
                },
              ),

              const Divider(height: 1, color: Colors.white10), 

              /* Delete */ 
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.redAccent),
                title: const Text('Delete User'),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, user);
                },
              ),
              
              const SizedBox(height: 8), 
            ],
          ),
        ),
      ),
    );
  }

  /* Edit User Dialog */
  void _showEditDialog(BuildContext context, dynamic user) {
  final firstNameController = TextEditingController(text: user.first_Name);
  final lastNameController = TextEditingController(text: user.last_Name);
  final emailController = TextEditingController(text: user.email);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit User Profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: "First Name"),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: "Last Name"),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
           ),
         ],
        ),
     ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            context.read<UserBloc>().add(
              UpdateUserEvent(
                id: user.id,
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                email: emailController.text
              )
            );
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

/* Delete Confirmation Dialog */
void _showDeleteConfirmation(BuildContext context, dynamic user) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Delete'),
      content: Text('Are you sure you want to remove ${user.first_Name}?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            context.read<UserBloc>().add(DeleteUserEvent(user.id));
            Navigator.pop(context);
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

  /* Create User Dialog */
  void _showAddUserDialog(BuildContext context) {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: "First Name"),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: "Last Name"),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (firstNameController.text.isNotEmpty && lastNameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                context.read<UserBloc>().add(
                  AddUserEvent(
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  email: emailController.text
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}