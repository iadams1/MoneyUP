import 'package:flutter/material.dart';
import 'package:moneyup/features/education/screens/education.dart';
import 'package:moneyup/features/profile/screens/profile.dart';
import 'package:moneyup/features/transactions/screens/transactions_home.dart';
import 'package:moneyup/main.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({
    super.key,
    required this.currentIndex
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const MyHomePage(title: 'MoneyUP'),
      const TransactionsHome(),
      const EducationScreen(),
      const ProfileScreen(),
    ];

    final List<_NavItem> items = [
      _NavItem(
        selected: 'assets/icons/homeIcon.png',
        unselected: 'assets/icons/unselectedHomeIcon.png'
      ),
      _NavItem(
        selected: 'assets/icons/transactionsIcon.png',
        unselected: 'assets/icons/unselectedTransactionsIcon.png'
      ),
      _NavItem(
        selected: 'assets/icons/educationIcon.png',
        unselected: 'assets/icons/unselectedEducationIcon.png'
      ),
      _NavItem(
        selected: 'assets/icons/settingsIcon.png',
        unselected: 'assets/icons/unselectedSettingsIcon.png'
      ),
    ];

    return BottomAppBar(
      color: const Color.fromARGB(0, 255, 253, 249),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = currentIndex == index;

          return IconButton(
            onPressed: () {
              if (index == currentIndex) return;
              Navigator.push(context, MaterialPageRoute(builder: (_) => pages[index]));
            }, 
            icon: Image.asset(
              isSelected
                ? items[index].selected
                : items[index].unselected,
              // height: 28,
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final String selected;
  final String unselected;

  _NavItem({
    required this.selected,
    required this.unselected
  });
}