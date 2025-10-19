import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pemrograman_mobile/screens/login_screen.dart';
import 'package:pemrograman_mobile/screens/add_expense_screen.dart';
import 'package:pemrograman_mobile/widgets/custom_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('expenses');
    if (data != null) {
      setState(() {
        expenses = List<Map<String, dynamic>>.from(jsonDecode(data));
      });
    }
  }

  Future<void> _saveExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('expenses', jsonEncode(expenses));
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  int getTotalExpense() {
    int total = 0;
    for (var e in expenses) {
      total += e['amount'] as int;
    }
    return total;
  }

  void _deleteExpense(int index) async {
    setState(() {
      expenses.removeAt(index);
    });
    await _saveExpenses();
  }

  List<FlSpot> _generateChartData() {
    // Kita pakai tanggal (hari) sebagai X dan jumlah pengeluaran sebagai Y
    Map<int, double> dailyTotal = {};
    for (var e in expenses) {
      final dateParts = e['date'].split('/');
      final day = int.parse(dateParts[0]);
      final amount = (e['amount'] as int).toDouble();
      dailyTotal[day] = (dailyTotal[day] ?? 0) + amount;
    }

    final sortedDays = dailyTotal.keys.toList()..sort();
    return sortedDays
        .map((day) => FlSpot(day.toDouble(), dailyTotal[day]! / 1000)) // dibagi 1000 biar skala bagus
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final totalExpense = getTotalExpense();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- TOTAL EXPENSE SECTION ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Pengeluaran Bulan Ini",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Rp $totalExpense",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- CHART SECTION ---
            if (expenses.isNotEmpty) ...[
              const Text(
                "Grafik Pengeluaran Harian (x: hari, y: ribuan rupiah)",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 180,
                child: LineChart(
                  LineChartData(
                    backgroundColor: Colors.white,
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 3,
                        spots: _generateChartData(),
                        dotData: FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            const Text(
              "Riwayat Transaksi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: expenses.isEmpty
                  ? const Center(child: Text("Belum ada pengeluaran"))
                  : ListView.builder(
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final e = expenses[index];
                        return Dismissible(
                          key: UniqueKey(),
                          background: Container(
                            color: Colors.redAccent,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => _deleteExpense(index),
                          child: ExpenseTile(
                            title: e['title'],
                            amount: e['amount'],
                            date: e['date'],
                            icon: Icons.attach_money,
                            color: Colors.green,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
          );
          _loadExpenses();
        },
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class ExpenseTile extends StatelessWidget {
  final String title;
  final int amount;
  final String date;
  final IconData icon;
  final Color color;

  const ExpenseTile({
    super.key,
    required this.title,
    required this.amount,
    required this.date,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(date),
        trailing: Text(
          "- Rp $amount",
          style: const TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
