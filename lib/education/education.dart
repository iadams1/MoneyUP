import 'dart:async';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moneyup/education/categorydetails.dart';

import '../education/widgets/article_card.dart';

import 'package:moneyup/main.dart';
import 'package:moneyup/profile.dart';
import 'package:moneyup/transactions/transactions_home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moneyup/education/viewallarticles.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  late Future<List<Map<String, dynamic>>> _randomArticles;
  late Future<List<Map<String, dynamic>>> _dailyTipsFuture;

  int _currentTipIndex = 0;
  Timer? _rotationTimer;
  List<Map<String, dynamic>> _tips = [];

  late final List<String> categories = const [
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

  Future<List<Map<String, dynamic>>> fetchRandomArticles() async {
    final response = await Supabase.instance.client.rpc(
      'get_random_articles',
      params: {'p_limit': 2},
    );

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchDailyTips() async {
    debugPrint('fetchDailyTips CALLED');

    final response = await Supabase.instance.client.rpc('get_today_tips');

    debugPrint('fetchDailyTips RESPONSE: $response');

    return List<Map<String, dynamic>>.from(response);
  }

  void _startRotation() {
    _rotationTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted || _tips.isEmpty) return;

      setState(() {
        _currentTipIndex = (_currentTipIndex + 1) % _tips.length;
      });
    });
  }

  @override
  void dispose() {
    _rotationTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _randomArticles = fetchRandomArticles();
    _dailyTipsFuture = fetchDailyTips();
  }

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
              Container(
                // NOTIFICATION ICON
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
            child: Image.asset(
              // BACKGROUND
              'assets/images/mu_bg.png',
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            // WHITE BOX CONTAINER
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
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
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: _dailyTipsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Text('No tips available');
                            }

                            // Load tips once
                            if (_tips.isEmpty) {
                              _tips = snapshot.data!;
                              _startRotation();
                            }

                            _tips = snapshot.data!;
                            if (_rotationTimer == null) _startRotation();

                            final tip = _tips[_currentTipIndex];

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Container with tip content
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                          16,
                                          0,
                                          0,
                                          0,
                                        ),
                                        offset: Offset(0, 8),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  height: 130,
                                  width: 380,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.fromLTRB(
                                    25,
                                    25,
                                    25,
                                    0,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        tip['tip_summary'],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        tip['display_title'],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Dot indicators below the container
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(_tips.length, (
                                    index,
                                  ) {
                                    return AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      width: _currentTipIndex == index ? 10 : 8,
                                      height: _currentTipIndex == index
                                          ? 10
                                          : 8,
                                      decoration: BoxDecoration(
                                        color: _currentTipIndex == index
                                            ? Colors.black
                                            : Colors.grey[300],
                                        shape: BoxShape.circle,
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              spacing: 170,
                              children: [
                                Text(
                                  "Articles",
                                  style: TextStyle(
                                    fontSize: 34,
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (_) => ViewAllArticlesScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "See All",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(156, 156, 156, 1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),

                            // 2 Articles and See All Button
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future: _randomArticles,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }

                                final articles = snapshot.data!;
                                if (articles.isEmpty) {
                                  return const Text('No articles available.');
                                }

                                return Column(
                                  spacing: 15,
                                  children: articles
                                      .map((a) => ArticleCard(article: a))
                                      .toList(),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
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
                          itemBuilder: (context, index, realIdx) {
                            final category = categories[index];
                            return Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CategoryDetailsScreen(category: category)
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: colorGradient[index],
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      categories[index],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30.0,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                )
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 120.0,
                            autoPlay: false,
                            enlargeCenterPage: false,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.7,
                            enableInfiniteScroll: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                    builder: (_) => MyHomePage(title: 'MoneyUp'),
                  ),
                );
              },
            ),
            IconButton(
              icon: Image.asset('assets/icons/unselectedTransactionsIcon.png'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => TransactionsHome()),
                );
              },
            ),
            IconButton(
              icon: Image.asset('assets/icons/educationIcon.png'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => EducationScreen()),
                );
              },
            ),
            IconButton(
              icon: Image.asset('assets/icons/unselectedSettingsIcon.png'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
