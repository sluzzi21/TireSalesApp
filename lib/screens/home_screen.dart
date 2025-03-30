import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../providers/quote_provider.dart';
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
          Consumer<QuoteProvider>(
            builder: (ctx, quoteProvider, child) {
              if (quoteProvider.currentQuote == null) {
                return IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Create New Quote'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Customer Name',
                              ),
                              onChanged: (value) => customerName = value,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Customer Phone',
                              ),
                              onChanged: (value) => customerPhone = value,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Create'),
                            onPressed: () {
                              if (customerName.isNotEmpty &&
                                  customerPhone.isNotEmpty) {
                                quoteProvider.createNewQuote(
                                    customerName, customerPhone);
                                Navigator.of(context).pop();
                                Navigator.of(context).pushNamed('/quote');
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/quote');
                  },
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false, // Prevent dismissing by clicking outside
                builder: (ctx) => const AddTireDialog(),
              );
            },
          ),
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
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Tires',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                Provider.of<InventoryProvider>(context, listen: false)
                    .searchTires(value);
              },
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
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/add-samples');
                          },
                          child: const Text('Add Sample Tires'),
                        ),
                      ],
                    ),
                  );
                }

                final tires = provider.tires;
                if (tires.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'No tires found. Add some tires to get started!',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/add-samples');
                          },
                          child: const Text('Add Sample Tires'),
                        ),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TireList(tires: tires),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false, // Prevent dismissing by clicking outside
            builder: (ctx) => const AddTireDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  static String customerName = '';
  static String customerPhone = '';
}
