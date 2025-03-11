import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tire_sales_app/providers/inventory_provider.dart';
import 'package:tire_sales_app/screens/home_screen.dart';
import 'package:tire_sales_app/services/storage_service.dart';

void main() {
  debugPrint('Starting app initialization...');
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('Flutter bindings initialized');
  
  try {
    final storageService = StorageService();
    debugPrint('StorageService created successfully');
    runApp(MyApp(storageService: storageService));
    debugPrint('MyApp started');
  } catch (e) {
    debugPrint('Error during app initialization: $e');
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  
  const MyApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    debugPrint('Building MyApp widget');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            debugPrint('Creating InventoryProvider');
            return InventoryProvider(storageService);
          },
        ),
      ],
      child: MaterialApp(
        title: 'Tire Sales App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
