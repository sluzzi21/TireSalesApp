import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../models/tire.dart';
import '../widgets/tire_list.dart';
import '../widgets/add_tire_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tire Sales App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<InventoryProvider>().loadTires();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: SearchBar(
                    hintText: 'Search tires...',
                    onChanged: (query) {
                      context.read<InventoryProvider>().searchTires(query);
                    },
                    leading: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AddTireDialog(),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Tire'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<InventoryProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (provider.error != null && provider.error!.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, 
                          size: 64, 
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          provider.error!,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            provider.loadTires();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final tires = provider.tires;
                if (tires.isEmpty) {
                  return const Center(
                    child: Text(
                      'No tires found. Add some tires to get started!',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return TireList(tires: tires);
              },
            ),
          ),
        ],
      ),
    );
  }
}
