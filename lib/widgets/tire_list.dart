import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tire.dart';
import '../providers/inventory_provider.dart';
import 'edit_tire_dialog.dart';

class TireList extends StatelessWidget {
  final List<Tire> tires;

  const TireList({super.key, required this.tires});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tires.length,
      itemBuilder: (context, index) {
        final tire = tires[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildInfoColumn('Brand', tire.brand),
                      const SizedBox(width: 16),
                      _buildInfoColumn('Model', tire.model),
                      const SizedBox(width: 16),
                      _buildInfoColumn('Width', tire.width),
                      const SizedBox(width: 16),
                      _buildInfoColumn('Ratio', tire.ratio),
                      const SizedBox(width: 16),
                      _buildInfoColumn('Diameter', tire.diameter),
                      const SizedBox(width: 16),
                      _buildInfoColumn('Category', tire.category),
                      const SizedBox(width: 16),
                      _buildInfoColumn('Price', '\$${tire.price.toStringAsFixed(2)}'),
                      const SizedBox(width: 16),
                      _buildInfoColumn('Quantity', tire.quantity.toString()),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => EditTireDialog(tire: tire),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Tire'),
                              content: Text(
                                'Are you sure you want to delete ${tire.brand} ${tire.model}?'
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<InventoryProvider>().deleteTire(tire.id);
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (tire.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Description: ${tire.description}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
