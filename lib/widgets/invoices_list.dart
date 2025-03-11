import 'package:flutter/material.dart';
import '../models/invoice.dart';
import '../services/database_helper.dart';
import 'package:intl/intl.dart';

class InvoicesList extends StatefulWidget {
  const InvoicesList({super.key});

  @override
  State<InvoicesList> createState() => _InvoicesListState();
}

class _InvoicesListState extends State<InvoicesList> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Invoice> _invoices = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    final invoices = await _dbHelper.getAllInvoices();
    setState(() {
      _invoices = invoices;
    });
  }

  List<Invoice> _getFilteredInvoices() {
    if (_searchQuery.isEmpty) return _invoices;
    final query = _searchQuery.toLowerCase();
    return _invoices.where((invoice) {
      return invoice.customerName.toLowerCase().contains(query) ||
          invoice.customerPhone.contains(query) ||
          invoice.id.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredInvoices = _getFilteredInvoices();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search Invoices',
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
          child: filteredInvoices.isEmpty
              ? const Center(
                  child: Text('No invoices found'),
                )
              : ListView.builder(
                  itemCount: filteredInvoices.length,
                  itemBuilder: (context, index) {
                    final invoice = filteredInvoices[index];
                    return InvoiceListItem(
                      invoice: invoice,
                      onMarkAsPaid: () async {
                        final updatedInvoice = Invoice(
                          id: invoice.id,
                          quoteId: invoice.quoteId,
                          customerName: invoice.customerName,
                          customerPhone: invoice.customerPhone,
                          items: invoice.items,
                          dueDate: invoice.dueDate,
                          createdAt: invoice.createdAt,
                          isPaid: true,
                        );
                        await _dbHelper.updateInvoice(updatedInvoice);
                        _loadInvoices();
                      },
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

class InvoiceListItem extends StatelessWidget {
  final Invoice invoice;
  final VoidCallback onMarkAsPaid;

  const InvoiceListItem({
    super.key,
    required this.invoice,
    required this.onMarkAsPaid,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text('Invoice #${invoice.id.substring(0, 8)}'),
        subtitle: Text(
          '${invoice.customerName} - ${dateFormat.format(invoice.createdAt)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$${invoice.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              invoice.isPaid ? Icons.check_circle : Icons.pending,
              color: invoice.isPaid
                  ? Colors.green
                  : Theme.of(context).colorScheme.error,
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Due Date: ${dateFormat.format(invoice.dueDate)}'),
                Text('Phone: ${invoice.customerPhone}'),
                Text('Quote ID: ${invoice.quoteId}'),
                const Divider(),
                const Text(
                  'Items:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: invoice.items.length,
                  itemBuilder: (context, index) {
                    final item = invoice.items[index];
                    return ListTile(
                      dense: true,
                      title: Text('Tire ID: ${item.tireId}'),
                      subtitle: Text('Quantity: ${item.quantity}'),
                      trailing: Text('\$${item.price.toStringAsFixed(2)}'),
                    );
                  },
                ),
                if (!invoice.isPaid)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: onMarkAsPaid,
                          child: const Text('Mark as Paid'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
