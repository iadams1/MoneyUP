import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mu_copy/main.dart';
import 'package:mu_copy/profile.dart';
import 'package:mu_copy/transactions/transactions_home.dart';

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
  
  int get _selectedIndex => 2;

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
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 34,
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
                                  colors: [
                                    HexColor('#33E84C'),
                                    HexColor('#7ce88b'),
                                    HexColor('#adeab5'),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12.0)
                              ),
                              child: Center(
                                child: Text(
                                  categories[index],
                                  style: TextStyle(
                                    color: Colors.white, 
                                    fontSize: 20.0,
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
              color: Colors.grey[400]
            ), 
            selectedIcon: ImageIcon(
              AssetImage('assets/icons/homeIcon.png'),
              color: HexColor('#0F52BA'),
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
              color: HexColor('#0F52BA'),
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