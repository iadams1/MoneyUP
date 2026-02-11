import 'package:moneyup/features/education/screens/education.dart';
import 'package:moneyup/features/mywallet/widgets/add_card_dialog.dart';
import 'package:moneyup/features/mywallet/widgets/linked_card_tile.dart';
import 'package:moneyup/features/mywallet/widgets/page_indicator.dart';
import 'package:moneyup/features/mywallet/widgets/wallet_card.dart';
import 'package:moneyup/models/linked_card.dart';
import 'package:moneyup/features/proflie/screens/profile.dart';

import 'package:flutter/material.dart';
import 'package:moneyup/features/transactions/screens/transactions_home.dart';
import 'package:moneyup/main.dart';
import 'package:moneyup/services/service_locator.dart';
import 'package:moneyup/shared/screen/loading_screen.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({super.key});

  @override
  State<MyWallet> createState() => _MyWallet();
}

class _MyWallet extends State<MyWallet> {
  bool _isLoading = true;
  List<LinkedCard> _cards = [];

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
    setState(() {
      _isLoading = true;
    });

    try {
      final cards = await walletService.fetchLinkedCards();
      if (!mounted) return;

      setState(() {
        _cards = cards;
        _isLoading = false;
        
      });
    } catch (e) {
      debugPrint('Error loading cards: $e');
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
    final cards = _cards;

    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
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
                padding: EdgeInsets.only(top: 5),
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
        toolbarHeight: 180,
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
              height: 590,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(45.0)),
                color: Colors.white,
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            top: 220,
            bottom: 140,
            child: SizedBox(
              height: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 250,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: cards.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentCard = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final card = cards[index];
                        return WalletCard(
                          cardId: index,
                          bankName: card.bankName ?? "Unknown Bank", 
                          mask: card.mask, 
                          currentAmount: card.currentBalance ?? 0.0, 
                          cardholderName: card.cardholderName ?? "",
                        );
                      }
                    ),
                  ),

                  PageIndicatorDots(
                    count: cards.length,
                    currentIndex: _currentCard,
                  ),


                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Cards",
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "${cards.length} Linked",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(55, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 20),
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        final card = cards[index];
                        return LinkedCardTile(
                          cardId: index, 
                          card: card, 
                          onDelete: () {});
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 725,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const AddCardDialog(),
                );
              },
              child: Image.asset("assets/icons/plusCircle.png"),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(0, 255, 255, 255),
        height: 70,
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
}
