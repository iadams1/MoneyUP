import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hexcolor/hexcolor.dart';

import '/features/education/screens/categorydetails.dart';
import '/features/education/screens/viewallarticles.dart';
import '/models/article.dart';
import '/models/daily_tip.dart';
import '/shared/screen/loading_screen.dart';
import '/shared/widgets/profile_menu.dart';
import '/shared/widgets/bottom_nav.dart';
import '/features/education/widgets/article_card.dart';
import '/services/service_locator.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  bool _isLoading = true;
  List<Article> _articles = [];
  List<DailyTip> _tips = [];

  int _currentTipIndex = 0;
  Timer? _rotationTimer;

  static const categories = [
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

  void _startRotation() {
    _rotationTimer?.cancel();
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
    _loadEducation();
  }

  Future<void> _loadEducation() async {
    try {
      final articles = await articleService.fetchRandomArticles();
      final tips = await articleService.fetchDailyTips();

      if (!mounted) return;

      setState(() {
        _articles = articles;
        _tips = tips;
        _currentTipIndex = 0;
        _isLoading = false;
      });

      if (tips.isNotEmpty) _startRotation();
    } catch (e) {
      debugPrint('Error loading article: $e');
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _isLoading
          ? const LoadingScreen(key: ValueKey('loading'))
          : _buildContent(context, key: const ValueKey('content')),
    );
  }

  Widget _buildContent(BuildContext context, {required Key key}) {
    final tip = _tips[_currentTipIndex];
    final articles = _articles;

    return Scaffold(
      key: key,
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
              ProfileMenuCard(),
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
                          
                          Column(
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
                                      tip.tipSummary,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      tip.displayTitle,
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
                          ),

                          SizedBox(height: 10),

                          Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              Column(
                                spacing: 15,
                                children: articles
                                    .map((a) => ArticleCard(article: a)).toList(),
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
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }
}
