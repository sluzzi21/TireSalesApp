import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class SupabaseTestScreen extends StatefulWidget {
  const SupabaseTestScreen({super.key});

  @override
  State<SupabaseTestScreen> createState() => _SupabaseTestScreenState();
}

class _SupabaseTestScreenState extends State<SupabaseTestScreen> {
  bool _isLoading = false;
  String _status = 'Not connected';
  List<Map<String, dynamic>> _tires = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    // Initialize Supabase when screen loads
    Future.microtask(() => _initializeSupabase());
  }

  Future<void> _initializeSupabase() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _status = 'Initializing Supabase...';
    });

    try {
      bool alreadyInitialized = false;
      try {
        Supabase.instance;
        alreadyInitialized = true;
        setState(() => _status = 'Already connected to Supabase');
      } catch (_) {}

      if (!alreadyInitialized) {
        await Supabase.initialize(
          url: SupabaseConfig.url,
          anonKey: SupabaseConfig.anonKey,
        );
        setState(() => _status = 'Connected to Supabase');
      }
      
      // Test connection by querying tires
      setState(() => _status = '$_status\nTesting connection...');
      await _queryTires();
      setState(() => _status = '$_status\nSuccessfully queried tires table');
    } catch (e) {
      setState(() {
        _error = 'Connection error: ${e.toString()}';
        _status = 'Failed to connect';
      });
      print('Supabase error: $e'); // For debugging
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _queryTires() async {
    try {
      setState(() => _status = '$_status\nQuerying tires table...');
      
      final response = await Supabase.instance.client
          .from('tires')
          .select()
          .limit(10);

      if (response == null) {
        throw Exception('No response from Supabase');
      }

      setState(() {
        _tires = List<Map<String, dynamic>>.from(response);
        _error = null;
      });
    } catch (e) {
      setState(() => _error = 'Query error: ${e.toString()}');
      print('Query error: $e'); // For debugging
      rethrow; // Allow parent to handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Connection Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _initializeSupabase,
          ),
        ],
      ),
      body: Padding(
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
                    Text('Status: $_status',
                        style: Theme.of(context).textTheme.titleMedium),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: LinearProgressIndicator(),
                      ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(_error!,
                            style: const TextStyle(color: Colors.red)),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tires Section
            if (_tires.isNotEmpty) ...[
              Text('First ${_tires.length} tires:',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _tires.length,
                  itemBuilder: (context, index) {
                    final tire = _tires[index];
                    return Card(
                      child: ListTile(
                        title: Text('${tire['brand']} ${tire['model'] ?? ''}'),
                        subtitle: Text(
                            '${tire['width']}/${tire['ratio']}R${tire['diameter']}'),
                        trailing: Text('\$${tire['price'] ?? 0.0}'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
