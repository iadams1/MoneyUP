import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mu_copy/education/education.dart';
import 'package:mu_copy/main.dart';
import 'package:mu_copy/profile.dart';

class TransactionsHome extends StatelessWidget {
  const TransactionsHome({super.key});
  
  int get _selectedIndex => 1;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        height: 80,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage(title: ''))
              );
            break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TransactionsHome())
              );
            break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => EducationScreen())
              );
            break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen())
              );
            break;
          }
        }, 
        indicatorColor: Colors.transparent,
        destinations: [
          NavigationDestination(
            icon: ImageIcon(
              AssetImage('assets/icons/homeIcon.png'),
              color: Colors.grey[400],
            ), 
            selectedIcon: ImageIcon(
              AssetImage('assets/icons/homeIcon.png'),
              color: HexColor('#000080'),
            ), 
            label: '',
          ),
          NavigationDestination(
            icon: ImageIcon(
              AssetImage('assets/icons/transactionsIcon.png'),
              color: Colors.grey[900],
            ), 
            selectedIcon: ImageIcon(
              AssetImage('assets/icons/transactionsIcon.png'),
              color: HexColor('#000080'),
            ), 
            label: '',
          ),
          NavigationDestination(
            icon: ImageIcon(
              AssetImage('assets/icons/educationIcon.png'),
              color: Colors.grey[900],
            ), 
            selectedIcon: ImageIcon(
              AssetImage('assets/icons/educationIcon.png'),
              color: HexColor('#000080'),
            ), 
            label: '',
          ),
          NavigationDestination(
            icon: ImageIcon(
              AssetImage('assets/icons/settingsIcon.png'),
            ),
            selectedIcon: ImageIcon(
              AssetImage('assets/icons/settingsIcon.png'),
              color: HexColor('#0F52BA'),
            ), 
            label: '',
          ),
        ],
      ),
    );
  }
}