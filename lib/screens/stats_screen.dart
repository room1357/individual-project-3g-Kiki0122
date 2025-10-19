import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pemrograman_mobile/widgets/custom_navbar.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final income = 2500000;
    final expense = 1200000;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Ringkasan Keuangan Bulan Ini",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.green,
                      value: income.toDouble(),
                      title: 'Pemasukan',
                      radius: 80,
                      titleStyle: const TextStyle(color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: Colors.red,
                      value: expense.toDouble(),
                      title: 'Pengeluaran',
                      radius: 80,
                      titleStyle: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Card(
              color: Colors.green[50],
              child: ListTile(
                leading: const Icon(Icons.arrow_downward, color: Colors.green),
                title: const Text('Total Pemasukan'),
                trailing: Text("Rp$income",
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.red[50],
              child: ListTile(
                leading: const Icon(Icons.arrow_upward, color: Colors.red),
                title: const Text('Total Pengeluaran'),
                trailing: Text("Rp$expense",
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 2),
    );
  }
}
