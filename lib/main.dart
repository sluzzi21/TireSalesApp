import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tire_sales_app/providers/inventory_provider.dart';
import 'package:tire_sales_app/screens/home_screen.dart';
import 'package:tire_sales_app/services/storage_service.dart';
import 'package:tire_sales_app/scripts/add_sample_tires.dart';

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
            final provider = InventoryProvider(storageService);
            debugPrint('InventoryProvider created');
            return provider;
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
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/add-samples': (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Add Sample Tires'),
            ),
            body: Center(
              child: FutureBuilder(
                future: addSampleTires(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Sample tires added successfully!'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        child: const Text('Go to Home'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        },
      ),
    );
  }
}
