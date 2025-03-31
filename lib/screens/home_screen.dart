import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../models/tire.dart';
import '../widgets/add_tire_dialog.dart';
import '../widgets/tire_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tire Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Tire',
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => const AddTireDialog(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              context.read<InventoryProvider>().loadTires();
            },
          ),
          IconButton(
            icon: const Icon(Icons.dataset),
            tooltip: 'Add Sample Data',
            onPressed: () {
              Navigator.pushNamed(context, '/add-samples');
            },
          ),
        ],
      ),
      body: Consumer<InventoryProvider>(
        builder: (context, inventoryProvider, child) {
          final tires = inventoryProvider.filteredTires;
          return TireList(tires: tires);
        },
      ),
    );
  }
}
