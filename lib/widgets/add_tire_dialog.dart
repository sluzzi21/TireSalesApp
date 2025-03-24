import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tire.dart';
import '../providers/inventory_provider.dart';

class AddTireDialog extends StatefulWidget {
  const AddTireDialog({super.key});

  @override
  State<AddTireDialog> createState() => _AddTireDialogState();
}

class _AddTireDialogState extends State<AddTireDialog> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _widthController = TextEditingController();
  final _ratioController = TextEditingController();
  final _diameterController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _widthController.dispose();
    _ratioController.dispose();
    _diameterController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final tire = Tire(
        brand: _brandController.text,
        model: _modelController.text,
        width: _widthController.text,
        ratio: _ratioController.text,
        diameter: _diameterController.text,
        category: _categoryController.text,
        price: double.parse(_priceController.text),
        description: _descriptionController.text,
      );

      context.read<InventoryProvider>().addTire(tire);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Tire'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Brand'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a brand';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: 'Model'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a model';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _widthController,
                decoration: const InputDecoration(labelText: 'Width'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a width';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ratioController,
                decoration: const InputDecoration(labelText: 'Ratio'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a ratio';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _diameterController,
                decoration: const InputDecoration(labelText: 'Diameter'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a diameter';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
