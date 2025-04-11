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
  final _formKey = GlobalKey<FormState>();
  String _brand = '';
  String? _model;
  String _width = '';
  String _ratio = '';
  String _diameter = '';
  String? _category;
  double? _price;
  String? _description;
  int _quantity = 1;
  String? _storage_location1;
  String? _storage_location2;
  String? _storage_location3;

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<InventoryProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final dropdownWidth = width * 0.25; // Set dropdown width to 25% of screen width

    // Helper function to wrap dropdowns with consistent width
    Widget wrapDropdown(Widget dropdown) {
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: dropdownWidth),
        child: dropdown,
      );
    }

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: width * 0.15, vertical: 24.0),
      child: AlertDialog(
        title: const Text('Add New Tire'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Brand Dropdown
                wrapDropdown(
                  DropdownButtonFormField<String>(
                    value: _brand.isEmpty ? null : _brand,
                    decoration: const InputDecoration(labelText: 'Brand *'),
                    items: [
                      ...inventoryProvider.distinctBrands.map((brand) => DropdownMenuItem(
                            value: brand,
                            child: Text(brand),
                          )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _brand = value ?? '';
                        _model = null; // Reset model when brand changes
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a brand';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Model Dropdown
                wrapDropdown(
                  DropdownButtonFormField<String>(
                    value: _model,
                    decoration: const InputDecoration(labelText: 'Model'),
                    items: [
                      ...inventoryProvider.getDistinctModelsForBrand(_brand).map((model) => DropdownMenuItem(
                            value: model,
                            child: Text(model),
                          )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _model = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Width, Ratio, Diameter Row
                Row(
                  children: [
                    // Width Dropdown
                    Expanded(
                      child: wrapDropdown(
                        DropdownButtonFormField<String>(
                          value: _width.isEmpty ? null : _width,
                          decoration: const InputDecoration(labelText: 'Width *'),
                          items: [
                            ...inventoryProvider.distinctWidths.map((width) => DropdownMenuItem(
                                  value: width,
                                  child: Text(width),
                                )),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _width = value ?? '';
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Ratio Dropdown
                    Expanded(
                      child: wrapDropdown(
                        DropdownButtonFormField<String>(
                          value: _ratio.isEmpty ? null : _ratio,
                          decoration: const InputDecoration(labelText: 'Ratio *'),
                          items: [
                            ...inventoryProvider.distinctRatios.map((ratio) => DropdownMenuItem(
                                  value: ratio,
                                  child: Text(ratio),
                                )),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _ratio = value ?? '';
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Diameter Dropdown
                    Expanded(
                      child: wrapDropdown(
                        DropdownButtonFormField<String>(
                          value: _diameter.isEmpty ? null : _diameter,
                          decoration: const InputDecoration(labelText: 'Diameter *'),
                          items: [
                            ...inventoryProvider.distinctDiameters.map((diameter) => DropdownMenuItem(
                                  value: diameter,
                                  child: Text(diameter),
                                )),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _diameter = value ?? '';
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Category Dropdown
                wrapDropdown(
                  DropdownButtonFormField<String>(
                    value: _category,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: [
                      ...inventoryProvider.distinctCategories.map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _category = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Price Field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    prefixText: '\$',
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
                  decoration: const InputDecoration(labelText: 'Description'),
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Quantity Field
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Quantity *'),
                  keyboardType: TextInputType.number,
                  initialValue: '1',
                  onChanged: (value) {
                    setState(() {
                      _quantity = int.tryParse(value) ?? 1;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    }
                    final quantity = int.tryParse(value);
                    if (quantity == null || quantity < 1) {
                      return 'Please enter a valid quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Storage Locations Row
                Row(
                  children: [
                    // Storage Location 1 Dropdown
                    Expanded(
                      child: wrapDropdown(
                        DropdownButtonFormField<String>(
                          value: _storage_location1,
                          decoration: const InputDecoration(labelText: 'Storage 1'),
                          items: [
                            ...inventoryProvider.distinctStorageLocations1.map((location) => DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                )),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _storage_location1 = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Storage Location 2 Dropdown
                    Expanded(
                      child: wrapDropdown(
                        DropdownButtonFormField<String>(
                          value: _storage_location2,
                          decoration: const InputDecoration(labelText: 'Storage 2'),
                          items: [
                            ...inventoryProvider.distinctStorageLocations2.map((location) => DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                )),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _storage_location2 = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Storage Location 3 Dropdown
                    Expanded(
                      child: wrapDropdown(
                        DropdownButtonFormField<String>(
                          value: _storage_location3,
                          decoration: const InputDecoration(labelText: 'Storage 3'),
                          items: [
                            ...inventoryProvider.distinctStorageLocations3.map((location) => DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                )),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _storage_location3 = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final tire = Tire(
                  id: const Uuid().v4(),
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

                inventoryProvider.addTire(tire);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
