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
  late final TextEditingController _brandController;
  late final TextEditingController _modelController;
  late final TextEditingController _widthController;
  late final TextEditingController _ratioController;
  late final TextEditingController _diameterController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late String _category;

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController(text: widget.tire.brand);
    _modelController = TextEditingController(text: widget.tire.model);
    _widthController = TextEditingController(text: widget.tire.width);
    _ratioController = TextEditingController(text: widget.tire.ratio);
    _diameterController = TextEditingController(text: widget.tire.diameter);
    _priceController = TextEditingController(text: widget.tire.price.toString());
    _descriptionController = TextEditingController(text: widget.tire.description);
    _category = widget.tire.category;
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _widthController.dispose();
    _ratioController.dispose();
    _diameterController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final updatedTire = Tire(
        id: widget.tire.id,
        brand: _brandController.text,
        model: _modelController.text,
        width: _widthController.text,
        ratio: _ratioController.text,
        diameter: _diameterController.text,
        price: double.parse(_priceController.text),
        description: _descriptionController.text,
        category: _category,
      );

      context.read<InventoryProvider>().updateTire(updatedTire);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Tire'),
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
          child: const Text('Save'),
        ),
      ],
    );
  }
}
