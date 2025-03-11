import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import '../models/tire.dart';

class TestFirebaseScreen extends StatefulWidget {
  const TestFirebaseScreen({super.key});

  @override
  State<TestFirebaseScreen> createState() => _TestFirebaseScreenState();
}

class _TestFirebaseScreenState extends State<TestFirebaseScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  String _status = 'Not tested';
  List<Tire> _tires = [];

  Future<void> _testConnection() async {
    try {
      setState(() {
        _status = 'Testing connection...';
      });

      // Test writing to Firestore
      final testTire = Tire(
        id: DateTime.now().toString(),
        brand: 'Test Brand',
        model: 'Test Model',
        size: '205/55R16',
        price: 100.0,
        quantity: 1,
        description: 'Test tire',
      );

      await _firebaseService.addTire(testTire);
      
      // Test reading from Firestore
      final tires = await _firebaseService.getAllTires();
      
      setState(() {
        _status = 'Connection successful! Found ${tires.length} tires.';
        _tires = tires;
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  Future<void> _clearTestData() async {
    try {
      setState(() {
        _status = 'Clearing test data...';
      });

      await _firebaseService.clearAllData();
      
      setState(() {
        _status = 'Test data cleared successfully';
        _tires = [];
      });
    } catch (e) {
      setState(() {
        _status = 'Error clearing data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Connection Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connection Status:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(_status),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _testConnection,
                  child: const Text('Test Connection'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _clearTestData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Clear Test Data'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Tires in Database:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _tires.length,
                itemBuilder: (context, index) {
                  final tire = _tires[index];
                  return Card(
                    child: ListTile(
                      title: Text('${tire.brand} ${tire.model}'),
                      subtitle: Text('Size: ${tire.size}, Price: \$${tire.price}'),
                      trailing: Text('Qty: ${tire.quantity}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
