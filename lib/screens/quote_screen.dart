import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quote_provider.dart';
import '../models/quote_item.dart';

class QuoteScreen extends StatelessWidget {
  const QuoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Quote'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Provider.of<QuoteProvider>(context, listen: false).saveQuote();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Quote saved successfully')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              Provider.of<QuoteProvider>(context, listen: false)
                  .clearCurrentQuote();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Consumer<QuoteProvider>(
        builder: (ctx, quoteProvider, child) {
          final quote = quoteProvider.currentQuote;
          if (quote == null) {
            return const Center(
              child: Text('No active quote'),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer: ${quote.customerName}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Phone: ${quote.customerPhone}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Total: \$${quote.total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: quote.items.length,
                  itemBuilder: (ctx, i) {
                    final item = quote.items[i];
                    final itemName = item.type == QuoteItemType.tire
                        ? '${item.item.brand} ${item.item.model}'
                        : item.item.name;
                    final itemPrice = item.totalPrice;

                    return ListTile(
                      title: Text(itemName),
                      subtitle: Text(
                          'Quantity: ${item.quantity} - \$${itemPrice.toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          quoteProvider.removeItemFromQuote(item.id);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'add_tires',
            onPressed: () {
              Navigator.of(context).pushNamed('/');
            },
            label: const Text('Add Tires'),
            icon: const Icon(Icons.tire_repair),
          ),
          const SizedBox(width: 16),
          FloatingActionButton.extended(
            heroTag: 'add_services',
            onPressed: () {
              Navigator.of(context).pushNamed('/services');
            },
            label: const Text('Add Services'),
            icon: const Icon(Icons.home_repair_service),
          ),
        ],
      ),
    );
  }
}
