import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moneyup/education/education.dart';
import 'package:moneyup/main.dart';
import 'package:moneyup/profile.dart';

class TransactionsHome extends StatelessWidget {
  const TransactionsHome({super.key});
  
  int get _selectedIndex => 1;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: EdgeInsets.only(top: 10, left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color.fromARGB(0, 255, 255, 255),
                  border: Border.all(
                    width: 3,
                    color: const Color.fromARGB(255, 121, 121, 121),
                  ),
                ),
                child: Image.asset('assets/icons/profileIcon.png'),
              ),
              Container( // NOTIFICATION ICON
                alignment: Alignment.topRight,
                padding: EdgeInsets.all(5),
                child: IconButton(
                  onPressed: () {
                    // print('Notification icon pressed');
                  }, 
                  icon: Icon(
                    Icons.notifications_outlined, 
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        toolbarHeight: 120,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset( // BACKGROUND
              'assets/images/mu_bg.png',
              fit: BoxFit.fill
            ),
          ),
          SafeArea( // WHITE BOX CONTAINER
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(50.0),
                ),
                color: Colors.white,
              ),
            ),
          ),
        ],
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
            icon: Icon(
              Icons.home_outlined,
              color: Colors.grey[400],
              size: 35
            ),
            selectedIcon: Icon(
              Icons.home_outlined,
              color: HexColor('#0F52BA'),
              size: 35
            ), 
            label: '',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.credit_card_outlined,
              color: Colors.grey[400],
              size: 35
            ), 
            selectedIcon: Icon(
              Icons.credit_card_outlined,
              color: HexColor('#0F52BA'),
              size: 35
            ), 
            label: '',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.menu_book_outlined,
              color: Colors.grey[400],
              size: 35
            ), 
            selectedIcon: Icon(
              Icons.menu_book_outlined,
              color: HexColor('#0F52BA'),
              size: 35
            ), 
            label: '',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outline,
              color: Colors.grey[400],
              size: 35
            ),
            selectedIcon: Icon(
              Icons.person_outline,
              color: HexColor('#0F52BA'),
              size: 35
            ), 
            label: '',
          ),
        ],
      ),
    );
  }
}