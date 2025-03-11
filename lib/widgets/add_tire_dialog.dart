import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/tire.dart';
import '../providers/inventory_provider.dart';

class AddTireDialog extends StatefulWidget {
  const AddTireDialog({super.key});

  @override
  State<AddTireDialog> createState() => _AddTireDialogState();
}

class _AddTireDialogState extends State<AddTireDialog> {
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _widthController = TextEditingController();
  final _ratioController = TextEditingController();
  final _diameterController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _category = 'All Season';

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _widthController.dispose();
    _ratioController.dispose();
    _diameterController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final newTire = Tire(
      id: const Uuid().v4(),
      brand: _brandController.text,
      model: _modelController.text,
      width: _widthController.text,
      ratio: _ratioController.text,
      diameter: _diameterController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      quantity: int.tryParse(_quantityController.text) ?? 0,
      description: _descriptionController.text,
      category: _category,
    );

    Provider.of<InventoryProvider>(context, listen: false).addTire(newTire);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Tire'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _brandController,
              decoration: const InputDecoration(labelText: 'Brand'),
            ),
            TextField(
              controller: _modelController,
              decoration: const InputDecoration(labelText: 'Model'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _widthController,
                    decoration: const InputDecoration(labelText: 'Width'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _ratioController,
                    decoration: const InputDecoration(labelText: 'Ratio'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _diameterController,
                    decoration: const InputDecoration(labelText: 'Diameter'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: const [
                DropdownMenuItem(value: 'All Season', child: Text('All Season')),
                DropdownMenuItem(value: 'Summer', child: Text('Summer')),
                DropdownMenuItem(value: 'Winter', child: Text('Winter')),
                DropdownMenuItem(value: 'Performance', child: Text('Performance')),
                DropdownMenuItem(value: 'All Terrain', child: Text('All Terrain')),
                DropdownMenuItem(value: 'Off Road', child: Text('Off Road')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _category = value);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_brandController.text.isNotEmpty &&
                _modelController.text.isNotEmpty &&
                _widthController.text.isNotEmpty &&
                _ratioController.text.isNotEmpty &&
                _diameterController.text.isNotEmpty &&
                _priceController.text.isNotEmpty &&
                _quantityController.text.isNotEmpty) {
              _handleSubmit();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
