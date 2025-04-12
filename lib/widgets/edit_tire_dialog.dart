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
  late String _brand;
  String? _model;
  late String _width;
  late String _ratio;
  late String _diameter;
  String? _category;
  double? _price;
  String? _description;
  late int _quantity;
  String? _storage_location1;
  String? _storage_location2;
  String? _storage_location3;

  @override
  void initState() {
    super.initState();
    _brand = widget.tire.brand;
    _model = widget.tire.model;
    _width = widget.tire.width;
    _ratio = widget.tire.ratio;
    _diameter = widget.tire.diameter;
    _category = widget.tire.category;
    _price = widget.tire.price;
    _description = widget.tire.description;
    _quantity = widget.tire.quantity;
    _storage_location1 = widget.tire.storage_location1;
    _storage_location2 = widget.tire.storage_location2;
    _storage_location3 = widget.tire.storage_location3;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final inventoryProvider = Provider.of<InventoryProvider>(context, listen: false);
        final updatedTire = Tire(
          id: widget.tire.id,
          brand: _brand,
          model: _model,
          width: _width,
          ratio: _ratio,
          diameter: _diameter,
          category: _category,
          price: _price,
          description: _description,
          quantity: _quantity,
          storage_location1: _storage_location1,
          storage_location2: _storage_location2,
          storage_location3: _storage_location3,
        );

        await inventoryProvider.updateTire(updatedTire);

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tire updated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating tire: $e')),
          );
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Dialog(
      child: Container(
        width: width * 0.7,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Tire',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                // Brand Field
                TextFormField(
                  initialValue: _brand,
                  decoration: const InputDecoration(labelText: 'Brand *'),
                  onChanged: (value) => setState(() => _brand = value),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter a brand' : null,
                ),
                const SizedBox(height: 16),
              // Model Field
              TextFormField(
                initialValue: _model,
                decoration: const InputDecoration(labelText: 'Model'),
                onChanged: (value) => setState(() => _model = value),
              ),
              const SizedBox(height: 16),
              // Width Field
              TextFormField(
                initialValue: _width,
                decoration: const InputDecoration(labelText: 'Width *'),
                onChanged: (value) => setState(() => _width = value),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a width' : null,
              ),
              const SizedBox(height: 16),

              // Ratio Field
              TextFormField(
                initialValue: _ratio,
                decoration: const InputDecoration(labelText: 'Ratio *'),
                onChanged: (value) => setState(() => _ratio = value),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a ratio' : null,
              ),
              const SizedBox(height: 16),

              // Diameter Field
              TextFormField(
                initialValue: _diameter,
                decoration: const InputDecoration(labelText: 'Diameter *'),
                onChanged: (value) => setState(() => _diameter = value),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a diameter' : null,
              ),
              const SizedBox(height: 16),

              // Category Field
              TextFormField(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                onChanged: (value) => setState(() => _category = value),
              ),
              const SizedBox(height: 16),
              // Price Field
              TextFormField(
                initialValue: _price?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixText: 'USD ',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _price = double.tryParse(value);
                  });
                },
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                initialValue: _description ?? '',
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) => setState(() => _description = value),
              ),
              const SizedBox(height: 16),

              // Quantity Field
              TextFormField(
                initialValue: _quantity?.toString() ?? '',
                decoration: const InputDecoration(labelText: 'Quantity *'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _quantity = int.tryParse(value) ?? 0;
                  });
                },
                validator: (value) =>
                    value == null || value.isEmpty || int.tryParse(value) == null
                        ? 'Please enter a valid quantity'
                        : null,
              ),
              const SizedBox(height: 16),

              // Storage Location Fields
              TextFormField(
                initialValue: _storage_location1 ?? '',
                decoration: const InputDecoration(labelText: 'Storage Location 1'),
                onChanged: (value) => setState(() => _storage_location1 = value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _storage_location2 ?? '',
                decoration: const InputDecoration(labelText: 'Storage Location 2'),
                onChanged: (value) => setState(() => _storage_location2 = value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _storage_location3 ?? '',
                decoration: const InputDecoration(labelText: 'Storage Location 3'),
                onChanged: (value) => setState(() => _storage_location3 = value),
              ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
