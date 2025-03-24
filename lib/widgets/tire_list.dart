import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tire.dart';
import '../providers/inventory_provider.dart';
import 'edit_tire_dialog.dart';

class TireList extends StatefulWidget {
  final List<Tire> tires;

  const TireList({super.key, required this.tires});

  @override
  State<TireList> createState() => _TireListState();
}

class _TireListState extends State<TireList> {
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  Widget _buildSearchField(String title, String column) {
    return Container(
      width: column == 'description' ? 300 : 120,
      padding: const EdgeInsets.only(left: 6),
      child: TextField(
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          hintText: 'Search $title...',
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        onChanged: (value) {
          context.read<InventoryProvider>().updateColumnFilter(column, value);
        },
      ),
    );
  }

  Widget _buildColumnHeader(String title, String column) {
    return Container(
      width: column == 'description' ? 300 : 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchField(title, column),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _verticalScrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _verticalScrollController,
        scrollDirection: Axis.vertical,
        child: Scrollbar(
          controller: _horizontalScrollController,
          thumbVisibility: true,
          notificationPredicate: (notification) => notification.depth == 1,
          child: SingleChildScrollView(
            controller: _horizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
              columnSpacing: 24,
              headingRowHeight: 85,
              dataRowHeight: 48,
              columns: [
                DataColumn(label: _buildColumnHeader('Brand', 'brand')),
                DataColumn(label: _buildColumnHeader('Model', 'model')),
                DataColumn(label: _buildColumnHeader('Width', 'width')),
                DataColumn(label: _buildColumnHeader('Ratio', 'ratio')),
                DataColumn(label: _buildColumnHeader('Diameter', 'diameter')),
                DataColumn(label: _buildColumnHeader('Category', 'category')),
                DataColumn(label: _buildColumnHeader('Price', 'price')),
                DataColumn(label: _buildColumnHeader('Description', 'description')),
                DataColumn(
                  label: Container(
                    padding: const EdgeInsets.only(left: 8),
                    child: const Text(
                      'Actions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
              rows: widget.tires.map((tire) {
                return DataRow(
                  cells: [
                    DataCell(Container(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(tire.brand),
                    )),
                    DataCell(Container(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(tire.model),
                    )),
                    DataCell(Container(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(tire.width.toString()),
                    )),
                    DataCell(Container(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(tire.ratio.toString()),
                    )),
                    DataCell(Container(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(tire.diameter.toString()),
                    )),
                    DataCell(Container(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(tire.category),
                    )),
                    DataCell(Container(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(tire.price.toStringAsFixed(2)),
                    )),
                    DataCell(Container(
                      padding: const EdgeInsets.only(left: 8),
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: Text(
                        tire.description,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                    DataCell(Container(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                            tooltip: 'Edit',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20, color: Colors.red),
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
                            tooltip: 'Delete',
                          ),
                        ],
                      ),
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
