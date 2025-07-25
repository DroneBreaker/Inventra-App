import 'package:flutter/material.dart';
import 'package:inventra/config/app_colors.dart';
import 'package:inventra/screens/create_invoice.dart';
import 'package:inventra/widgets/titles.dart';

// Dummy CreateInvoice Page
// class CreateInvoice extends StatelessWidget {
//   const CreateInvoice({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Create Invoice"),
//         backgroundColor: Colors.blue,
//       ),
//       body: const Center(child: Text("Create Invoice Page")),
//     );
//   }
// }

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> tabs = [
    "All",
    "Sales",
    "Purchase",
    "Refund",
    "Credit Note",
    "Debit Note"
  ];

  final List<Map<String, dynamic>> invoices = [
    {
      "number": "INV-2025-001",
      "type": "Sales",
      "client": "John Doe",
      "date": "23 Jul 2025",
      "total": "₵ 2,400.00",
      "items": [
        {"name": "Item A", "qty": 2, "price": 1000},
        {"name": "Item B", "qty": 1, "price": 400},
      ]
    },
    {
      "number": "INV-2025-002",
      "type": "Purchase",
      "client": "ABC Supplies",
      "date": "22 Jul 2025",
      "total": "₵ 1,200.00",
      "items": [
        {"name": "Item X", "qty": 3, "price": 400},
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Invoices"),
        backgroundColor: Colors.blue,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: tabs.map((e) => Tab(text: e)).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateInvoice()),
          );
        },
        icon: const Icon(Icons.add),
        label: appParagraph(title: "Add Invoice", color: AppColors.white),
        backgroundColor: AppColors.buttonSecondary,
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((tab) {
          // Filter logic could be added here
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              final invoice = invoices[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ExpansionTile(
                  leading: _getInvoiceTypeIcon(invoice['type']),
                  title: Text(invoice['number']),
                  subtitle: Text("${invoice['client']} | ${invoice['date']}"),
                  trailing: Text(
                    invoice['total'],
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    ...invoice['items'].map<Widget>((item) {
                      return ListTile(
                        title: Text(item['name']),
                        subtitle: Text("Qty: ${item['qty']}"),
                        trailing: Text("₵ ${item['price']}"),
                      );
                    }).toList(),
                  ],
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Icon _getInvoiceTypeIcon(String type) {
    switch (type) {
      case "Sales":
        return const Icon(Icons.shopping_cart, color: Colors.green);
      case "Purchase":
        return const Icon(Icons.store, color: Colors.blue);
      case "Refund":
        return const Icon(Icons.undo, color: Colors.red);
      case "Credit Note":
        return const Icon(Icons.note_add, color: Colors.orange);
      case "Debit Note":
        return const Icon(Icons.note, color: Colors.purple);
      default:
        return const Icon(Icons.receipt_long, color: Colors.grey);
    }
  }
}
