import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../services/database_helper.dart';
import 'package:intl/intl.dart';

class QuotesList extends StatefulWidget {
  const QuotesList({super.key});

  @override
  State<QuotesList> createState() => _QuotesListState();
}

class _QuotesListState extends State<QuotesList> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Quote> _quotes = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    final quotes = await _dbHelper.getAllQuotes();
    setState(() {
      _quotes = quotes;
    });
  }

  List<Quote> _getFilteredQuotes() {
    if (_searchQuery.isEmpty) return _quotes;
    final query = _searchQuery.toLowerCase();
    return _quotes.where((quote) {
      return quote.customerName.toLowerCase().contains(query) ||
          quote.customerPhone.contains(query) ||
          quote.id.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredQuotes = _getFilteredQuotes();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search Quotes',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        Expanded(
          child: filteredQuotes.isEmpty
              ? const Center(
                  child: Text('No quotes found'),
                )
              : ListView.builder(
                  itemCount: filteredQuotes.length,
                  itemBuilder: (context, index) {
                    final quote = filteredQuotes[index];
                    return QuoteListItem(
                      quote: quote,
                      onConvertToInvoice: () {
                        // TODO: Implement convert to invoice
                      },
                      onReleaseItems: () {
                        // TODO: Implement release items
                      },
                      onRefresh: _loadQuotes,
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class QuoteListItem extends StatelessWidget {
  final Quote quote;
  final VoidCallback onConvertToInvoice;
  final VoidCallback onReleaseItems;
  final VoidCallback onRefresh;

  const QuoteListItem({
    super.key,
    required this.quote,
    required this.onConvertToInvoice,
    required this.onReleaseItems,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text('Quote #${quote.id.substring(0, 8)}'),
        subtitle: Text(
          '${quote.customerName} - ${dateFormat.format(quote.createdAt)}',
        ),
        trailing: Text(
          '\$${quote.totalAmount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Created: ${timeFormat.format(quote.createdAt)}'),
                Text('Phone: ${quote.customerPhone}'),
                const Divider(),
                const Text(
                  'Items:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: quote.items.length,
                  itemBuilder: (context, index) {
                    final item = quote.items[index];
                    return ListTile(
                      dense: true,
                      title: Text('Tire ID: ${item.tireId}'),
                      subtitle: Text('Quantity: ${item.quantity}'),
                      trailing: Text('\$${item.price.toStringAsFixed(2)}'),
                    );
                  },
                ),
                const Divider(),
                if (!quote.isConverted)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: onReleaseItems,
                        child: const Text('Release Items'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: onConvertToInvoice,
                        child: const Text('Convert to Invoice'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
