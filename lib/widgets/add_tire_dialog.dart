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

  Widget wrapFormField(Widget child) {
    return SizedBox(
      height: 70,
      child: child,
    );
  }

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
    final dialogWidth = width * 0.7; // Match dialog width

    // Helper function to style autocomplete options
    Widget wrapAutocompleteOptions(Widget optionsView) {
      return Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: dialogWidth - 32, // Account for dialog padding
            maxHeight: 200,
          ),
          child: Material(
            elevation: 4,
            child: optionsView,
          ),
        ),
      );
    }

    return Dialog(
      child: Container(
        width: dialogWidth,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Tire',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Brand Autocomplete
                    Autocomplete<String>(
                      optionsViewBuilder: (context, onSelected, options) => wrapAutocompleteOptions(
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options.elementAt(index);
                            return ListTile(
                              title: Text(option),
                              onTap: () => onSelected(option),
                            );
                          },
                        ),
                      ),
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return inventoryProvider.distinctBrands;
                        }
                        return inventoryProvider.distinctBrands.where((brand) =>
                            brand.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                      },
                      initialValue: TextEditingValue(text: _brand),
                      onSelected: (String value) {
                        setState(() {
                          _brand = value;
                          _model = null; // Reset model when brand changes
                        });
                      },
                      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                        return TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            labelText: 'Brand *',
                            hintText: 'Select or enter new brand',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _brand = value;
                              _model = null; // Reset model when brand changes
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a brand';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Model Autocomplete
                    Autocomplete<String>(
                      optionsViewBuilder: (context, onSelected, options) => wrapAutocompleteOptions(
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options.elementAt(index);
                            return ListTile(
                              title: Text(option),
                              onTap: () => onSelected(option),
                            );
                          },
                        ),
                      ),
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return inventoryProvider.getDistinctModelsForBrand(_brand);
                        }
                        return inventoryProvider.getDistinctModelsForBrand(_brand).where((model) =>
                            model.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                      },
                      initialValue: TextEditingValue(text: _model ?? ''),
                      onSelected: (String value) {
                        setState(() {
                          _model = value;
                        });
                      },
                      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                        return TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            labelText: 'Model',
                            hintText: 'Select or enter new model',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _model = value;
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Width, Ratio, Diameter Row
                    Row(
                      children: [
                        // Width Autocomplete
                        Expanded(
                          child: wrapFormField(
                            Autocomplete<String>(
                              optionsViewBuilder: (context, onSelected, options) => wrapAutocompleteOptions(
                                ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final option = options.elementAt(index);
                                    return ListTile(
                                      title: Text(option),
                                      onTap: () => onSelected(option),
                                    );
                                  },
                                ),
                              ),
                              optionsBuilder: (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return inventoryProvider.distinctWidths;
                                }
                                return inventoryProvider.distinctWidths.where((width) =>
                                    width.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                              },
                              initialValue: TextEditingValue(text: _width),
                              onSelected: (String value) {
                                setState(() {
                                  _width = value;
                                });
                              },
                              fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                                return TextFormField(
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  decoration: const InputDecoration(labelText: 'Width *'),
                                  onChanged: (value) {
                                    setState(() {
                                      _width = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Ratio Autocomplete
                        Expanded(
                          child: wrapFormField(
                            Autocomplete<String>(
                              optionsViewBuilder: (context, onSelected, options) => wrapAutocompleteOptions(
                                ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final option = options.elementAt(index);
                                    return ListTile(
                                      title: Text(option),
                                      onTap: () => onSelected(option),
                                    );
                                  },
                                ),
                              ),
                              optionsBuilder: (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return inventoryProvider.distinctRatios;
                                }
                                return inventoryProvider.distinctRatios.where((ratio) =>
                                    ratio.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                              },
                              initialValue: TextEditingValue(text: _ratio),
                              onSelected: (String value) {
                                setState(() {
                                  _ratio = value;
                                });
                              },
                              fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                                return TextFormField(
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  decoration: const InputDecoration(labelText: 'Ratio *'),
                                  onChanged: (value) {
                                    setState(() {
                                      _ratio = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Diameter Autocomplete
                        Expanded(
                          child: wrapFormField(
                            Autocomplete<String>(
                              optionsViewBuilder: (context, onSelected, options) => wrapAutocompleteOptions(
                                ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final option = options.elementAt(index);
                                    return ListTile(
                                      title: Text(option),
                                      onTap: () => onSelected(option),
                                    );
                                  },
                                ),
                              ),
                              optionsBuilder: (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return inventoryProvider.distinctDiameters;
                                }
                                return inventoryProvider.distinctDiameters.where((diameter) =>
                                    diameter.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                              },
                              initialValue: TextEditingValue(text: _diameter),
                              onSelected: (String value) {
                                setState(() {
                                  _diameter = value;
                                });
                              },
                              fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                                return TextFormField(
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  decoration: const InputDecoration(labelText: 'Diameter *'),
                                  onChanged: (value) {
                                    setState(() {
                                      _diameter = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Category Autocomplete
                    Autocomplete<String>(
                      optionsViewBuilder: (context, onSelected, options) => wrapAutocompleteOptions(
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options.elementAt(index);
                            return ListTile(
                              title: Text(option),
                              onTap: () => onSelected(option),
                            );
                          },
                        ),
                      ),
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return inventoryProvider.distinctCategories;
                        }
                        return inventoryProvider.distinctCategories.where((category) =>
                            category.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                      },
                      initialValue: TextEditingValue(text: _category ?? ''),
                      onSelected: (String value) {
                        setState(() {
                          _category = value;
                        });
                      },
                      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                        return TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: const InputDecoration(labelText: 'Category'),
                          onChanged: (value) {
                            setState(() {
                              _category = value;
                            });
                          },
                        );
                      },
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

                    // Description Autocomplete
                    Autocomplete<String>(
                      optionsViewBuilder: (context, onSelected, options) => wrapAutocompleteOptions(
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options.elementAt(index);
                            return ListTile(
                              title: Text(option),
                              onTap: () => onSelected(option),
                            );
                          },
                        ),
                      ),
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return inventoryProvider.distinctDescriptions;
                        }
                        return inventoryProvider.distinctDescriptions.where((description) =>
                            description.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                      },
                      initialValue: TextEditingValue(text: _description ?? ''),
                      onSelected: (String value) {
                        setState(() {
                          _description = value;
                        });
                      },
                      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                        return TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: const InputDecoration(labelText: 'Description'),
                          onChanged: (value) {
                            setState(() {
                              _description = value;
                            });
                          },
                        );
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
                        // Storage Location 1 Input
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(labelText: 'Storage 1'),
                            onChanged: (value) {
                              setState(() {
                                _storage_location1 = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Storage Location 2 Input
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(labelText: 'Storage 2'),
                            onChanged: (value) {
                              setState(() {
                                _storage_location2 = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Storage Location 3 Input
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(labelText: 'Storage 3'),
                            onChanged: (value) {
                              setState(() {
                                _storage_location3 = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
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
                    onPressed: () async {
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

                        await inventoryProvider.addTire(tire); // Wait for the tire to be added
                        if (mounted) { // Check if widget is still mounted
                          Navigator.of(context).pop(); // Only pop if widget is still mounted
                        }
                      }
                    },
                    child: const Text('Add'),
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
