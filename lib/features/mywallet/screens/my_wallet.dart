import 'package:flutter/material.dart';

import '/features/education/screens/education.dart';
import '/features/mywallet/widgets/wallet_card.dart';
import '/features/profile/screens/profile.dart';
import '/features/transactions/screens/transactions_home.dart';
import '/shared/screen/loading_screen.dart';
import '/features/home/screens/my_home_page.dart';
import '/features/mywallet/widgets/add_card_dialog.dart';
import '/features/mywallet/widgets/linked_card_tile.dart';
import '/features/mywallet/widgets/page_indicator.dart';
import '/models/linked_card.dart';
import '/services/service_locator.dart';

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
        _cards = cards.where((card) => card.isActive == true).toList();
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

  Future<void> deleteCard(
    BuildContext context,
    dynamic accountId,
    String mask,
    String accountName,
    String? bankName,
  ) async {
    final bool? shouldDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "Delete Card",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    const BoxShadow(
                      color: Color.fromARGB(31, 0, 0, 0),
                      blurRadius: 12,
                    ),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                child: SizedBox(
                  height: 85,
                  width: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        accountName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      Text(
                        "****  ****  ****  $mask",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      Text(
                        bankName ?? "Unknown Bank",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(65, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Are you sure you want to delete this card?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  height: 1.1,
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
    if (shouldDelete == true) {
      await walletService.deleteCardAccount(accountId: accountId);
      if (!mounted) return;
      await _loadWallets();
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
                      },
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
                          onDelete: () {
                            deleteCard(
                              context,
                              card.accountId,
                              card.mask,
                              card.accountName,
                              card.bankName,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 175,
            right: 175,
            top: 795,
            bottom: 80,
            child: SizedBox(
              width: 10,
              height: 10,
              child: IconButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: 0,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AddCardDialog(),
                  );
                },
                icon: Image.asset("assets/icons/plusCircle.png"),
              ),
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
