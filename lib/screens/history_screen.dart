import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/widgets/custom_navbar.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // dummy data sementara
    final List<Map<String, dynamic>> history = [
      {"title": "Makan Siang", "amount": 35000, "date": "2025-10-19", "type": "expense"},
      {"title": "Gaji Bulanan", "amount": 2500000, "date": "2025-10-18", "type": "income"},
      {"title": "Kopi", "amount": 15000, "date": "2025-10-17", "type": "expense"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: history.length,
          itemBuilder: (context, index) {
            final item = history[index];
            final isExpense = item['type'] == 'expense';
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isExpense ? Colors.red[400] : Colors.green[400],
                  child: Icon(
                    isExpense ? Icons.arrow_upward : Icons.arrow_downward,
                    color: Colors.white,
                  ),
                ),
                title: Text(item['title']),
                subtitle: Text(item['date']),
                trailing: Text(
                  (isExpense ? '- ' : '+ ') + "Rp${item['amount']}",
                  style: TextStyle(
                    color: isExpense ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 1),
    );
  }
}
