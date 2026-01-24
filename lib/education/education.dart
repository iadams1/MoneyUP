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
    [HexColor('#0D1250'), HexColor('#A6F1A4')], // light green
    [HexColor('#0D1250'), HexColor('#79E1DE')], // light blue
    [HexColor('#0D1250'), HexColor('#E1A579')], // light orange
    [HexColor('#0D1250'), HexColor('#FC97F7')], // light pink
    [HexColor('#0D1250'), HexColor('#CD97FC')], // light purple
    [HexColor('#0D1250'), HexColor('#F5FC97')], // light yellow
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
                  SizedBox(height: 25),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
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
                                color: const Color.fromARGB(16, 0, 0, 0),
                                offset: Offset(0, 8),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          height: 140,
                          width: 380,
                          alignment: Alignment.topCenter,
                        ),
                        SizedBox(height: 10),
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              spacing: 190,
                              children: [
                                Text(
                                  "Articles",
                                  style: TextStyle(
                                    fontSize: 34,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "See All",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(156, 156, 156, 1)
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            // Add Cards later for database. Containers are placeholders
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(16, 0, 0, 0),
                                    offset: Offset(0, 8),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              height: 85,
                              width: 380,
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsetsGeometry.all(10),
                                child: Row(
                                  children: [
                                    // Category Icon
                                    Container(
                                      height: 80,
                                      width: 66,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: const Color.fromARGB(255, 57, 57, 57),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Article title
                                          Text(
                                            "Budgeting 101: How to Create a Budget",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                              height: 1.1,
                                              color: Colors.black
                                            ),
                                          ),
                                          // Artile author
                                          Text(
                                            "Rebecca Lake",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                              color: Colors.black
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    
                                    IconButton(
                                          icon: Image.asset(
                                            'assets/icons/chevronRightArrow.png',
                                          ),
                                          onPressed: () {},
                                        ),
                                  ],
                                ),
                              )
                            ),
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(16, 0, 0, 0),
                                    offset: Offset(0, 8),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              height: 85,
                              width: 380,
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsetsGeometry.all(10),
                                child: Row(
                                  children: [
                                    // Category Icon
                                    Container(
                                      height: 80,
                                      width: 66,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: const Color.fromARGB(255, 57, 57, 57),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Article title
                                          Text(
                                            "Credit Scorces and Why They Matter",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                              height: 1.1,
                                              color: Colors.black
                                            ),
                                          ),
                                          // Artile author
                                          Text(
                                            "CFPB",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                              color: Colors.black
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    
                                    IconButton(
                                      icon: Image.asset(
                                        'assets/icons/chevronRightArrow.png',
                                      ),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              )
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 34,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5),
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
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic
                                  ),
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 125.0,
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