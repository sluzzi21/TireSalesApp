import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../providers/auth_provider.dart';
import '../models/tire.dart';
import '../widgets/add_tire_dialog.dart';
import '../widgets/tire_list.dart';
import 'inventory_screen.dart';
import 'quote_screen.dart';
import 'manage_users_screen.dart';
import '../widgets/change_password_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tire Sales App'),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'change_password':
                    showDialog(
                      context: context,
                      builder: (ctx) => const ChangePasswordDialog(),
                    );
                    break;
                  case 'manage_users':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageUsersScreen(),
                      ),
                    );
                    break;
                  case 'logout':
                    context.read<AuthProvider>().logout();
                    break;
                  case 'add_tire':
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) => const AddTireDialog(),
                    );
                    break;
                  case 'refresh':
                    context.read<InventoryProvider>().loadTires();
                    break;
                  case 'add_sample_data':
                    Navigator.pushNamed(context, '/add-samples');
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                final authProvider = context.read<AuthProvider>();
                return [
                  const PopupMenuItem(
                    value: 'change_password',
                    child: ListTile(
                      leading: Icon(Icons.password),
                      title: Text('Change Password'),
                    ),
                  ),
                  if (authProvider.isAdmin)
                    const PopupMenuItem(
                      value: 'manage_users',
                      child: ListTile(
                        leading: Icon(Icons.people),
                        title: Text('Manage Users'),
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'add_tire',
                    child: ListTile(
                      leading: Icon(Icons.add),
                      title: Text('Add Tire'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'refresh',
                    child: ListTile(
                      leading: Icon(Icons.refresh),
                      title: Text('Refresh'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'add_sample_data',
                    child: ListTile(
                      leading: Icon(Icons.dataset),
                      title: Text('Add Sample Data'),
                    ),
                  ),
                ];
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.inventory), text: 'Inventory'),
              Tab(icon: Icon(Icons.request_quote), text: 'Quote'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Consumer<InventoryProvider>(
              builder: (context, inventoryProvider, child) {
                final tires = inventoryProvider.filteredTires;
                return TireList(tires: tires);
              },
            ),
            QuoteScreen(),
          ],
        ),
      ),
    );
  }
}
