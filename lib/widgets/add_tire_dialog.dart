import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tire.dart';
import '../providers/inventory_provider.dart';
import 'dart:developer' as developer;

class AddTireDialog extends StatefulWidget {
  const AddTireDialog({super.key});

  @override
  State<AddTireDialog> createState() => _AddTireDialogState();
}

class _AddTireDialogState extends State<AddTireDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _brand;
  String? _model;
  String? _width;
  String? _ratio;
  String? _diameter;
  String? _category;
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final tire = Tire(
        brand: _brand!,
        model: _model,
        width: _width!,
        ratio: _ratio!,
        diameter: _diameter!,
        category: _category,
        price: _priceController.text.isNotEmpty ? double.parse(_priceController.text) : null,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      );

      context.read<InventoryProvider>().addTire(tire);
      Navigator.of(context).pop();
    }
  }

  void _resetDependentFields(String field) {
    developer.log('Resetting dependent fields for: $field');
    // Only reset Model when Brand changes
    if (field == 'brand') {
      setState(() {
        _model = null;
      });
    }
    developer.log('After reset - Brand: $_brand, Model: $_model, Width: $_width, Ratio: $_ratio, Diameter: $_diameter, Category: $_category');
  }

  void _handleValueChange(String field, String? value) {
    developer.log('Handling value change for $field: $value');
    if (value == '_new_') {
      // Don't do anything when '_new_' is selected, wait for actual value
      developer.log('Selected "Enter new value..." for $field');
      return;
    }

    developer.log('Setting $field to $value');
    switch (field) {
      case 'brand':
        setState(() => _brand = value);
        _resetDependentFields(field); // Only call reset for brand changes
        break;
      case 'model':
        setState(() => _model = value);
        break;
      case 'width':
        setState(() => _width = value);
        break;
      case 'ratio':
        setState(() => _ratio = value);
        break;
      case 'diameter':
        setState(() => _diameter = value);
        break;
      case 'category':
        setState(() => _category = value);
        break;
    }
    developer.log('After value change - Brand: $_brand, Model: $_model, Width: $_width, Ratio: $_ratio, Diameter: $_diameter, Category: $_category');
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required String? value,
    required void Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    // Create a mutable list of items
    final List<String> dropdownItems = [...items];
    
    // If we have a value that's not in the list and not '_new_', add it
    if (value != null && !dropdownItems.contains(value) && value != '_new_') {
      developer.log('Adding new value $value to items for $label');
      dropdownItems.add(value);
      dropdownItems.sort();
    }

    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label),
      items: [
        ...dropdownItems.map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            )),
        const DropdownMenuItem(
          value: '_new_',
          child: Text('Enter new value...'),
        ),
      ],
      onChanged: (newValue) {
        developer.log('Dropdown onChanged for $label: $newValue');
        if (newValue == '_new_') {
          showDialog(
            context: context,
            builder: (context) {
              final controller = TextEditingController();
              return AlertDialog(
                title: Text('Enter new $label'),
                content: TextField(
                  controller: controller,
                  decoration: InputDecoration(labelText: label),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      developer.log('New value entered for $label: $value');
                      onChanged(value);
                      Navigator.of(context).pop();
                    }
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        developer.log('New value entered for $label: ${controller.text}');
                        onChanged(controller.text);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        } else {
          onChanged(newValue);
        }
      },
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InventoryProvider>();
    developer.log('Building AddTireDialog - Brand: $_brand, Model: $_model, Width: $_width, Ratio: $_ratio, Diameter: $_diameter, Category: $_category');

    return AlertDialog(
      title: const Text('Add New Tire'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDropdownField(
                label: 'Brand',
                items: provider.distinctBrands,
                value: _brand,
                onChanged: (value) => _handleValueChange('brand', value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a brand';
                  }
                  return null;
                },
              ),
              _buildDropdownField(
                label: 'Model (Optional)',
                items: provider.getDistinctModelsForBrand(_brand),
                value: _model,
                onChanged: (value) => _handleValueChange('model', value),
                validator: (_) => null, // Optional field always validates
              ),
              _buildDropdownField(
                label: 'Width',
                items: provider.distinctWidths,
                value: _width,
                onChanged: (value) => _handleValueChange('width', value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a width';
                  }
                  return null;
                },
              ),
              _buildDropdownField(
                label: 'Ratio',
                items: provider.distinctRatios,
                value: _ratio,
                onChanged: (value) => _handleValueChange('ratio', value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a ratio';
                  }
                  return null;
                },
              ),
              _buildDropdownField(
                label: 'Diameter',
                items: provider.distinctDiameters,
                value: _diameter,
                onChanged: (value) => _handleValueChange('diameter', value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a diameter';
                  }
                  return null;
                },
              ),
              _buildDropdownField(
                label: 'Category (Optional)',
                items: provider.distinctCategories,
                value: _category,
                onChanged: (value) => _handleValueChange('category', value),
                validator: (_) => null, // Optional field always validates
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price (Optional)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // Price is optional
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description (Optional)'),
                maxLines: 3,
                validator: (_) => null, // Optional field always validates
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
