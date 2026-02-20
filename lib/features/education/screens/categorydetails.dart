import 'dart:math';
import 'package:flutter/material.dart';

import '/models/article.dart';
import '/services/service_locator.dart';
import '/shared/screen/loading_screen.dart';
import '/shared/widgets/bottom_nav.dart';
import '/features/education/widgets/article_card.dart';
import '/shared/widgets/category_info.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final String category;
  const CategoryDetailsScreen({super.key, required this.category});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreen();
}

class _CategoryDetailsScreen extends State<CategoryDetailsScreen> {
  bool _isLoading = true;
  List<Article> _articles = [];

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  List<Article> getTwoDifferentArticles(List<Article> articles) {
    if (articles.length <= 2) return articles;
    final shuffled = List<Article>.from(articles)..shuffle(Random());
    return shuffled.take(2).toList();
  }

  Future<void> _loadArticles() async {
    try {
      final article = await articleService.getArticleByCategory(widget.category);
      if (!mounted) return;

      setState(() {
        _articles = article;
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
    final categoryInfo = categoryInfoMap[widget.category]!;
    final randomArticles = getTwoDifferentArticles(_articles);

    if (_articles.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No articles available.")),
      );
    }

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
          SafeArea(// WHITE BOX CONTAINER
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: IconButton(
                      icon: Image.asset('assets/icons/chevronLeftArrow.png'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.category,
                                  style: TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontSize: 36,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                                const SizedBox(height:6),
                                Text(
                                  categoryInfo.text,
                                  style: TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.only(left: 30),
                                  child: Text(
                                    'Why it Matters',
                                    style: TextStyle(
                                      fontFamily: 'SF Pro',
                                      fontSize: 26,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 30),
                                  child: Text(
                                    categoryInfo.whyItMatters,
                                    style: TextStyle(
                                      fontFamily: 'SF Pro',
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Best Practices',
                                  style: TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                                Column(
                                  children: categoryInfo.bestPractices.map((text)=>bulletItem(text)).toList(),
                                ),
                                const SizedBox(height: 15),
                                Column(
                                  spacing: 15,
                                  children: randomArticles.map((article)=>ArticleCard(article: article)).toList()
                                ),
                              ],
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }
}