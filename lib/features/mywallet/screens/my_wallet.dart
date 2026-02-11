import 'package:flutter/material.dart';

import '/features/education/screens/education.dart';
import '/features/mywallet/widgets/wallet_card.dart';
import '/features/profile/screens/profile.dart';
import '/features/transactions/screens/transactions_home.dart';
import '/main.dart';
import '/shared/screen/loading_screen.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({super.key});

  @override
  State<MyWallet> createState() => _MyWallet();
}

class _MyWallet extends State<MyWallet> {
  bool _isLoading = true;

  late final PageController _pageController;
  int _currentCard = 0;

  @override
  void initState() {
    super.initState();
    _loadWallets();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadWallets() async {
    try {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
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
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: EdgeInsets.only(top: 10, left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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

              Padding(
                padding: EdgeInsets.only(top: 25),
                child: IconButton(
                  icon: Image.asset('assets/icons/whiteChevronLeftArrow.png'),
                  alignment: Alignment.topLeft,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
        toolbarHeight: 200,
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
          
          Align(
            // WHITE BOX CONTAINER
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
                color: Colors.white,
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            top: 240,
            child: SizedBox(
              height: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 255,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: 3, // Change this later for user cards
                      onPageChanged: (index) {
                        setState(() {
                          _currentCard = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 30),
                          child: WalletCard(
                            bankName: "Bank of America",
                            mask: "4982",
                            currentAmount: 495.32,
                            cardholderName: "Isaiah Adams",
                          ),
                        );
                      },
                    ),
                  ),

                  buildDots(3), // Change this for later for user
                ],
              ),
            ),
          ),

          Row(

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
              icon: Image.asset('assets/icons/homeIcon.png'),
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
              icon: Image.asset('assets/icons/unselectedEducationIcon.png'),
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

  Widget buildDots(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == _currentCard;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 10,
          width: isActive ? 26 : 10,
          decoration: BoxDecoration(
            color: isActive ? Colors.black : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}
