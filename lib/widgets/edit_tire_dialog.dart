import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tire.dart';
import '../providers/inventory_provider.dart';

class EditTireDialog extends StatefulWidget {
  final Tire tire;

  const EditTireDialog({super.key, required this.tire});

  @override
  State<EditTireDialog> createState() => _EditTireDialogState();
}

class _EditTireDialogState extends State<EditTireDialog> {
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
  void initState() {
    super.initState();
    _brand = widget.tire.brand;
    _model = widget.tire.model;
    _width = widget.tire.width;
    _ratio = widget.tire.ratio;
    _diameter = widget.tire.diameter;
    _category = widget.tire.category;
    _priceController.text = widget.tire.price?.toString() ?? '';
    _descriptionController.text = widget.tire.description ?? '';
  }

  @override
  void dispose() {
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final updatedTire = Tire(
        id: widget.tire.id,
        brand: _brand!,
        model: _model,
        width: _width!,
        ratio: _ratio!,
        diameter: _diameter!,
        category: _category,
        price: _priceController.text.isNotEmpty ? double.parse(_priceController.text) : null,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      );

      context.read<InventoryProvider>().updateTire(updatedTire);
      Navigator.of(context).pop();
    }
  }

  void _handleValueChange(String field, String? value) {
    if (value == '_new_') {
      // Don't do anything when '_new_' is selected, wait for actual value
      return;
    }

    switch (field) {
      case 'brand':
        setState(() => _brand = value);
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
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required String? value,
    required void Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    final List<String> dropdownItems = [...items];

    if (value != null && !dropdownItems.contains(value) && value != '_new_') {
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

    return AlertDialog(
      title: const Text('Edit Tire'),
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
                validator: (_) => null, 
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
                validator: (_) => null, 
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price (Optional)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; 
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
                validator: (_) => null, 
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
          child: const Text('Save'),
        ),
      ],
    );
  }
}
