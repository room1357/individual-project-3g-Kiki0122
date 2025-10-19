import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/screens/home_screen.dart';
import 'package:pemrograman_mobile/screens/history_screen.dart';
import 'package:pemrograman_mobile/screens/stats_screen.dart';
import 'package:pemrograman_mobile/screens/profile_screen.dart';
import 'package:pemrograman_mobile/screens/add_expense_screen.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  const CustomNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HistoryScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StatsScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home,
                color: currentIndex == 0 ? Colors.blue : Colors.grey),
            onPressed: () => _onItemTapped(context, 0),
          ),
          IconButton(
            icon: Icon(Icons.history,
                color: currentIndex == 1 ? Colors.blue : Colors.grey),
            onPressed: () => _onItemTapped(context, 1),
          ),
          const SizedBox(width: 40), // Space for FAB
          IconButton(
            icon: Icon(Icons.bar_chart,
                color: currentIndex == 2 ? Colors.blue : Colors.grey),
            onPressed: () => _onItemTapped(context, 2),
          ),
          IconButton(
            icon: Icon(Icons.person,
                color: currentIndex == 3 ? Colors.blue : Colors.grey),
            onPressed: () => _onItemTapped(context, 3),
          ),
        ],
      ),
    );
  }
}
