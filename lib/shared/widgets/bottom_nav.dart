import 'package:flutter/material.dart';

import '/features/education/screens/education.dart';
import '/features/profile/screens/profile.dart';
import '/features/transactions/screens/transactions_home.dart';
import '/features/home/screens/my_home_page.dart';
import '/models/nav_items.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const MyHomePage(title: 'MoneyUP'),
      const TransactionsHome(),
      const EducationScreen(),
      const ProfileScreen(),
    ];

    final List<NavItem> items = [
      NavItem(
        selectedIcon: 'assets/icons/homeIcon.png',
        unselectedIcon: 'assets/icons/unselectedHomeIcon.png'
      ),
      NavItem(
        selectedIcon: 'assets/icons/transactionsIcon.png',
        unselectedIcon: 'assets/icons/unselectedTransactionsIcon.png'
      ),
      NavItem(
        selectedIcon: 'assets/icons/educationIcon.png',
        unselectedIcon: 'assets/icons/unselectedEducationIcon.png'
      ),
      NavItem(
        selectedIcon: 'assets/icons/settingsIcon.png',
        unselectedIcon: 'assets/icons/unselectedSettingsIcon.png'
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
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => pages[index]));
            }, 
            icon: Image.asset(
              isSelected
                ? items[index].selectedIcon
                : items[index].unselectedIcon,
              // height: 28,
            ),
          );
        }),
      ),
    );
  }
}