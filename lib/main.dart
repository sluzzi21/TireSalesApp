import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tire_sales_app/providers/auth_provider.dart';
import 'package:tire_sales_app/providers/inventory_provider.dart';
import 'package:tire_sales_app/screens/home_screen.dart';
import 'package:tire_sales_app/screens/login_screen.dart';
import 'package:tire_sales_app/services/auth_service.dart';
import 'package:tire_sales_app/services/storage_service.dart';
import 'package:tire_sales_app/widgets/change_password_dialog.dart';

void main() {
  debugPrint('Starting app initialization...');
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('Flutter bindings initialized');
  
  try {
    final storageService = StorageService();
    final authService = AuthService();
    debugPrint('Services created successfully');
    runApp(MyApp(storageService: storageService, authService: authService));
    debugPrint('MyApp started');
  } catch (e) {
    debugPrint('Error during app initialization: $e');
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  final AuthService authService;
  
  const MyApp({super.key, required this.storageService, required this.authService});

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
        ChangeNotifierProvider(
          create: (_) {
            debugPrint('Creating AuthProvider');
            return AuthProvider(authService);
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
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (!authProvider.isLoggedIn) {
              return const LoginScreen();
            }

            if (authProvider.currentUser?.requirePasswordChange ?? false) {
              // Show password change dialog if required
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => const ChangePasswordDialog(),
                );
              });
            }

            return const HomeScreen();
          },
        ),
      ),
    );
  }
}
