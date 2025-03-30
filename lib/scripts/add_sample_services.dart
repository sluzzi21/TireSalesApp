import 'package:flutter/material.dart';
import '../providers/services_provider.dart';

class AddSampleServices extends StatelessWidget {
  const AddSampleServices({super.key});

  void _addSampleServices(BuildContext context) {
    final provider = ServicesProvider();
    
    // Add sample services
    provider.addService(
      'Tire Mounting',
      'Professional tire mounting service per tire',
      25.00,
    );
    
    provider.addService(
      'Tire Balancing',
      'Computerized tire balancing service per tire',
      15.00,
    );
    
    provider.addService(
      'Wheel Alignment',
      'Four-wheel alignment service',
      89.99,
    );
    
    provider.addService(
      'Tire Rotation',
      'Rotate and inspect all four tires',
      39.99,
    );
    
    provider.addService(
      'TPMS Service',
      'Tire Pressure Monitoring System service and reset',
      29.99,
    );
    
    provider.addService(
      'Flat Repair',
      'Patch or plug tire repair service',
      24.99,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sample services added successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _addSampleServices(context),
        child: const Text('Add Sample Services'),
      ),
    );
  }
}
