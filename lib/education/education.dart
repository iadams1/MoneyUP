import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:moneyup/main.dart';
import 'package:moneyup/profile.dart';
import 'package:moneyup/transactions/transactions_home.dart';

class EducationScreen extends StatefulWidget{
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {

  final List<String> categories = const [
    'Budgeting',
    'Credit',
    'Debt',
    'Savings',
    'Banking',
    'Investing',
  ];

  final List<List<Color>> colorGradient = [
    [HexColor('#28A948'), HexColor('#56D776'), HexColor('#A0E9B2')], //green
    [HexColor('#28A9A1'), HexColor('#56D7CF'), HexColor('#A0E9E4')], //light blue
    [HexColor('#2860A9'), HexColor('#568ED7'), HexColor('#A0C0E9')], //dark blue
    [HexColor('#5928A9'), HexColor('#8756D7'), HexColor('#BCA0E9')], //purple
    [HexColor('#A9289C'), HexColor('#D756CA'), HexColor('#E9A0E1')], //pink
    [HexColor('#D60617'), HexColor('#FA3344'), HexColor('#FC8D96')], //yellow
  ];

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Daily Tips",
                          style: TextStyle(
                            fontSize: 34,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          height: 150,
                          width: 380,
                          alignment: Alignment.topCenter,
                        ),
                        Text(
                          "Articles",
                          style: TextStyle(
                            fontSize: 34,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 34,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        CarouselSlider.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index, realIdx){
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: colorGradient[index],
                                ),
                                borderRadius: BorderRadius.circular(12.0)
                              ),
                              child: Center(
                                child: Text(
                                  categories[index],
                                  style: TextStyle(
                                    color: Colors.white, 
                                    fontSize: 30.0,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic
                                  ),
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 150.0,
                            autoPlay: false,
                            enlargeCenterPage: false,
                            aspectRatio: 16/9,
                            viewportFraction: 0.7,
                            enableInfiniteScroll: true
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(0, 255, 253, 249),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Image.asset('assets/icons/unselectedHomeIcon.png'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => MyHomePage(title: 'MoneyUp',),
                  ),
                );
              },
            ),
            IconButton(
              icon: Image.asset('assets/icons/unselectedTransactionsIcon.png'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => TransactionsHome(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Image.asset('assets/icons/educationIcon.png'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => EducationScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Image.asset('assets/icons/unselectedSettingsIcon.png'),
              onPressed: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => ProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}