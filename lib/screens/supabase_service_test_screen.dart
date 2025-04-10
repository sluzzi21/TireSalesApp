import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/tire.dart';

class SupabaseServiceTestScreen extends StatefulWidget {
  const SupabaseServiceTestScreen({super.key});

  @override
  State<SupabaseServiceTestScreen> createState() => _SupabaseServiceTestScreenState();
}

class _SupabaseServiceTestScreenState extends State<SupabaseServiceTestScreen> {
  final _service = SupabaseService.instance;
  String _status = 'Not started';
  List<Tire> _tires = [];
  String? _error;
  String? _lastCreatedTireId;

  Future<void> _runTest(String name, Future<void> Function() test) async {
    try {
      setState(() {
        _status = 'Running $name...';
        _error = null;
      });
      await test();
      setState(() => _status = '$name completed successfully');
    } catch (e, stackTrace) {
      final errorDetails = '$name error:\n$e\n\nStack trace:\n$stackTrace';
      setState(() {
        _error = errorDetails;
        _status = '$name failed';
      });
      print(errorDetails);
    }
  }

  Future<void> _testInitialize() async {
    await _runTest('Initialize', () async {
      await _service.initialize();
    });
  }

  Future<void> _testGetTires() async {
    await _runTest('Get Tires', () async {
      final tires = await _service.getTires();
      setState(() => _tires = tires);
      print('Found ${tires.length} tires');
    });
  }

  Future<void> _testAddTire() async {
    await _runTest('Add Tire', () async {
      final newTire = Tire(
        brand: 'Test Brand',
        model: 'Test Model',
        width: '225',
        ratio: '65',
        diameter: '17',
        price: 199.99,
        category: 'Test',
        description: 'Test tire created at ${DateTime.now()}',
        quantity: 1,
      );

      final addedTire = await _service.addTire(newTire);
      setState(() => _lastCreatedTireId = addedTire.id);
      print('Added tire with ID: ${addedTire.id}');
    });
  }

  Future<void> _testUpdateTire() async {
    if (_lastCreatedTireId == null) {
      setState(() => _error = 'No tire to update. Create a tire first.');
      return;
    }

    await _runTest('Update Tire', () async {
      final tire = await _service.getTireById(_lastCreatedTireId!);
      if (tire == null) throw Exception('Tire not found');

      final updatedTire = Tire(
        id: tire.id,
        brand: tire.brand,
        model: '${tire.model} (Updated)',
        width: tire.width,
        ratio: tire.ratio,
        diameter: tire.diameter,
        price: tire.price,
        category: tire.category,
        description: '${tire.description} - Updated at ${DateTime.now()}',
        quantity: tire.quantity + 1,
      );

      await _service.updateTire(updatedTire);
      print('Updated tire with ID: ${updatedTire.id}');
    });
  }

  Future<void> _testDeleteTire() async {
    if (_lastCreatedTireId == null) {
      setState(() => _error = 'No tire to delete. Create a tire first.');
      return;
    }

    await _runTest('Delete Tire', () async {
      await _service.deleteTire(_lastCreatedTireId!);
      print('Deleted tire with ID: $_lastCreatedTireId');
      setState(() => _lastCreatedTireId = null);
    });
  }

  Future<void> _testSearch() async {
    await _runTest('Search Tires', () async {
      final results = await _service.searchTires(
        brand: 'Test',
        minPrice: 100,
        maxPrice: 300,
      );
      print('Found ${results.length} tires matching search criteria');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Service Tests'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      'Status: $_status',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SelectableText(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    if (_lastCreatedTireId != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SelectableText(
                          'Last created tire ID: $_lastCreatedTireId',
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Test Buttons
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ElevatedButton(
                  onPressed: _testInitialize,
                  child: const Text('1. Initialize'),
                ),
                ElevatedButton(
                  onPressed: _testGetTires,
                  child: const Text('2. Get Tires'),
                ),
                ElevatedButton(
                  onPressed: _testAddTire,
                  child: const Text('3. Add Tire'),
                ),
                ElevatedButton(
                  onPressed: _testUpdateTire,
                  child: const Text('4. Update Tire'),
                ),
                ElevatedButton(
                  onPressed: _testDeleteTire,
                  child: const Text('5. Delete Tire'),
                ),
                ElevatedButton(
                  onPressed: _testSearch,
                  child: const Text('6. Search'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Results Section
            if (_tires.isNotEmpty) ...[
              Text('Found ${_tires.length} tires:',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _tires.length,
                itemBuilder: (context, index) {
                  final tire = _tires[index];
                  return Card(
                    child: ListTile(
                      title: SelectableText('${tire.brand} ${tire.model}'),
                      subtitle: SelectableText(
                          '${tire.size} - \$${tire.price?.toStringAsFixed(2) ?? "N/A"}'),
                      trailing: SelectableText('Qty: ${tire.quantity}'),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
