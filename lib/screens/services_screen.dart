import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/services_provider.dart';
import '../providers/quote_provider.dart';
import '../widgets/add_service_dialog.dart';
import '../widgets/edit_service_dialog.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => const AddServiceDialog(),
              );
            },
          ),
        ],
      ),
      body: Consumer<ServicesProvider>(
        builder: (ctx, servicesProvider, child) {
          final services = servicesProvider.services;
          if (services.isEmpty) {
            return const Center(
              child: Text('No services available'),
            );
          }

          return ListView.builder(
            itemCount: services.length,
            itemBuilder: (ctx, i) {
              final service = services[i];
              return ListTile(
                title: Text(service.name),
                subtitle: Text(service.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('\$${service.price.toStringAsFixed(2)}'),
                    Consumer<QuoteProvider>(
                      builder: (ctx, quoteProvider, child) {
                        if (quoteProvider.currentQuote != null) {
                          return IconButton(
                            icon: const Icon(Icons.add_shopping_cart),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Add to Quote'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Add ${service.name} to quote?'),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        initialValue: '1',
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: 'Quantity',
                                        ),
                                        onFieldSubmitted: (value) {
                                          final quantity = int.tryParse(value) ?? 1;
                                          quoteProvider.addServiceToQuote(
                                              service, quantity);
                                          Navigator.of(context).pop();
                                        },
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
                                      child: const Text('Add'),
                                      onPressed: () {
                                        quoteProvider.addServiceToQuote(
                                            service, 1);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => EditServiceDialog(service: service),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Service'),
                            content: const Text(
                                'Are you sure you want to delete this service?'),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Delete'),
                                onPressed: () {
                                  servicesProvider.deleteService(service.id);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
