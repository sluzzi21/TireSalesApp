import 'package:uuid/uuid.dart';
import '../models/tire.dart';
import '../services/database_helper.dart';

class SampleData {
  static final _uuid = Uuid();

  static Future<void> loadSampleTires() async {
    final tires = [
      Tire(
        id: _uuid.v4(),
        brand: 'Michelin',
        model: 'Pilot Sport 4S',
        size: '245/40R18',
        price: 299.99,
        quantity: 8,
        description: 'High-performance summer tire',
      ),
      Tire(
        id: _uuid.v4(),
        brand: 'Goodyear',
        model: 'Eagle F1',
        size: '225/45R17',
        price: 249.99,
        quantity: 12,
        description: 'Ultra-high performance all-season tire',
      ),
      Tire(
        id: _uuid.v4(),
        brand: 'Continental',
        model: 'ExtremeContact DWS06',
        size: '235/35R19',
        price: 279.99,
        quantity: 6,
        description: 'All-season performance tire',
      ),
      Tire(
        id: _uuid.v4(),
        brand: 'Bridgestone',
        model: 'Potenza RE980AS',
        size: '255/40R18',
        price: 289.99,
        quantity: 10,
        description: 'High-performance all-season tire',
      ),
      Tire(
        id: _uuid.v4(),
        brand: 'Pirelli',
        model: 'P Zero',
        size: '265/35R20',
        price: 349.99,
        quantity: 4,
        description: 'Ultra-high performance summer tire',
      ),
    ];

    for (var tire in tires) {
      await DatabaseHelper.instance.insertTire(tire);
    }
  }
}
