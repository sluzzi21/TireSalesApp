import 'package:flutter/material.dart';
import '../models/tire.dart';
import '../services/storage_service.dart';
import 'package:uuid/uuid.dart';

Future<void> addSampleTires() async {
  debugPrint('Adding sample tires...');
  final storageService = StorageService();

  final sampleTires = [
    Tire(
      id: const Uuid().v4(),
      brand: 'Michelin',
      model: 'Pilot Sport 4S',
      width: '245',
      ratio: '40',
      diameter: '18',
      price: 225.99,
      quantity: 8,
      description: 'High-performance summer tire with excellent grip and handling',
      category: 'Performance',
    ),
    Tire(
      id: const Uuid().v4(),
      brand: 'Goodyear',
      model: 'Assurance WeatherReady',
      width: '215',
      ratio: '55',
      diameter: '17',
      price: 165.50,
      quantity: 12,
      description: 'All-season tire with superior wet weather performance',
      category: 'All Season',
    ),
    Tire(
      id: const Uuid().v4(),
      brand: 'Bridgestone',
      model: 'Blizzak WS90',
      width: '225',
      ratio: '65',
      diameter: '17',
      price: 185.75,
      quantity: 6,
      description: 'Winter tire with exceptional snow and ice performance',
      category: 'Winter',
    ),
    Tire(
      id: const Uuid().v4(),
      brand: 'Continental',
      model: 'ExtremeContact DWS06 Plus',
      width: '255',
      ratio: '35',
      diameter: '19',
      price: 245.99,
      quantity: 4,
      description: 'Ultra-high performance all-season tire',
      category: 'Performance',
    ),
    Tire(
      id: const Uuid().v4(),
      brand: 'Pirelli',
      model: 'Scorpion Verde All Season Plus II',
      width: '235',
      ratio: '60',
      diameter: '18',
      price: 195.50,
      quantity: 10,
      description: 'SUV/Crossover all-season tire with low rolling resistance',
      category: 'All Season',
    ),
    Tire(
      id: const Uuid().v4(),
      brand: 'Yokohama',
      model: 'GEOLANDAR A/T G015',
      width: '265',
      ratio: '70',
      diameter: '17',
      price: 175.99,
      quantity: 8,
      description: 'All-terrain tire for light trucks and SUVs',
      category: 'All Terrain',
    ),
    Tire(
      id: const Uuid().v4(),
      brand: 'Toyo',
      model: 'Open Country M/T',
      width: '285',
      ratio: '75',
      diameter: '16',
      price: 289.99,
      quantity: 4,
      description: 'Mud-terrain tire for extreme off-road performance',
      category: 'Off Road',
    ),
    Tire(
      id: const Uuid().v4(),
      brand: 'Firestone',
      model: 'Destination LE3',
      width: '225',
      ratio: '65',
      diameter: '17',
      price: 145.99,
      quantity: 16,
      description: 'Highway all-season tire for SUVs and light trucks',
      category: 'All Season',
    ),
    Tire(
      id: const Uuid().v4(),
      brand: 'BFGoodrich',
      model: 'g-Force COMP-2 A/S PLUS',
      width: '205',
      ratio: '50',
      diameter: '17',
      price: 155.99,
      quantity: 6,
      description: 'Ultra-high performance all-season tire',
      category: 'Performance',
    ),
    Tire(
      id: const Uuid().v4(),
      brand: 'Hankook',
      model: 'Ventus V12 evo2',
      width: '225',
      ratio: '45',
      diameter: '18',
      price: 168.75,
      quantity: 8,
      description: 'Summer performance tire with excellent dry grip',
      category: 'Performance',
    ),
  ];

  try {
    // Get existing tires
    final existingTires = await storageService.loadTires();
    
    // Only add tires if none exist
    if (existingTires.isEmpty) {
      debugPrint('No existing tires found, adding sample data...');
      for (final tire in sampleTires) {
        await storageService.addTire(tire);
        debugPrint('Added tire: ${tire.brand} ${tire.model}');
      }
      debugPrint('Sample tires added successfully');
    } else {
      debugPrint('Existing tires found, skipping sample data');
    }
  } catch (e) {
    debugPrint('Error adding sample tires: $e');
  }
}
