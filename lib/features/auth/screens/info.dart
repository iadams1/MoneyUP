import 'package:flutter/material.dart';
import 'package:moneyup/features/home/screens/my_home_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:hexcolor/hexcolor.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;
  int _currentIndex = 0;

  final List<_InfoScreenData> introData = const [
    _InfoScreenData(
      logo: 'assets/images/mu_logo.png',
      image: 'assets/images/mu_info1.png',
      description: "MoneyUp is built to help you take control of your finances-without the stress. Whether you're just starting out or leveling up, we're here to make money feel manageable."
    ),
    _InfoScreenData(
      logo: 'assets/images/mu_logo.png',
      image: 'assets/images/mu_info2.png',
      description: "Track your spending, set goals, and build habits that stick. MoneyUp turns your financial data into clear insights and actionable steps."
    ),
    _InfoScreenData(
      logo: 'assets/images/mu_logo.png',
      image: 'assets/images/mu_info3.png',
      description: "Money isn't just numbers—it's freedom, choices, and peace of mind. Start building the habits that lead to long-term confidence."
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final newIndex = (_controller.page ?? 0).round();
      if (newIndex != _currentIndex) {
        setState(() => _currentIndex = newIndex);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit:StackFit.expand,
        children: <Widget> [
          Image.asset(
            'assets/images/mu_info_bg.png',
            fit: BoxFit.fill
          ),
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: introData.length,
                  itemBuilder: (context, i) {
                    final p = introData[i];
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 60, 20, 0),
                            child: Image.asset(
                              p.logo,
                              height: 140,
                              fit: BoxFit.contain
                            ),
                          ),
                        ),
                        // const Spacer(flex: 2),
                        Expanded(
                          flex: 10,
                          child: Image.asset(
                            p.image, 
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        const Spacer(flex: 1),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 30),
                          child: Text(
                            p.description,
                            style:
                              const TextStyle(
                                fontFamily: 'SF Pro',
                                fontSize: 20, 
                                color: Colors.black
                              ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [ // SmoothPageIndicator with DotsDecorator
                    SmoothPageIndicator(
                      controller: _controller,
                      count: introData.length,
                      effect: ExpandingDotsEffect(
                        dotHeight: 10,
                        dotWidth: 10,
                        spacing: 8,
                        expansionFactor: 3,
                        dotColor: Colors.grey.shade300,
                        activeDotColor: Theme.of(context).primaryColor,
                      ),
                      onDotClicked: (index) => _controller.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      ),
                    ),
                    Padding( // NEXT BUTTON
                      padding: const EdgeInsets.all(30.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: AlignmentGeometry.centerRight,
                            colors: <HexColor>[
                              HexColor('#124074'), 
                              HexColor('#332677'),
                              HexColor('#124074'), 
                              HexColor('#0D1250'),
                            ],
                            tileMode: TileMode.mirror,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (_currentIndex < introData.length - 1) {
                              _controller.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut);
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const MyHomePage(title: '')),
                              );
                              // _completeOnboarding();
                            }
                          },
                          child: Text(
                            _currentIndex < introData.length - 1 ? 'Next': 'Get Started',
                            style: TextStyle(color: Colors.white, fontSize: 16.0)
                            ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoScreenData {
  final String logo;
  final String image;
  final String description;
  const _InfoScreenData({
    required this.logo,
    required this.image,
    required this.description,
  });
}