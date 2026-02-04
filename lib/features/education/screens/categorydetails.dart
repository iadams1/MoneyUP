import 'package:flutter/material.dart';
import 'package:moneyup/features/education/screens/education.dart';
import 'package:moneyup/features/proflie/screens/profile.dart';
import 'package:moneyup/features/transactions/screens/transactions_home.dart';
import 'package:moneyup/main.dart';
import 'package:moneyup/shared/widgets/article_card.dart';
import 'package:moneyup/shared/widgets/category_info.dart';
import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';

// import '../education/widgets/category_info.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final String category;
  const CategoryDetailsScreen({super.key, required this.category});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreen();
}

class _CategoryDetailsScreen extends State<CategoryDetailsScreen> {
  late Future<List<Map<String, dynamic>>> _categoryArticles;

  @override
  void initState() {
    super.initState();
    _categoryArticles = getArticleByCategory(widget.category);
  }

  Future<List<Map<String, dynamic>>> getArticleByCategory(String category) async {
    final response = await Supabase.instance.client
        .from('Educational')
        .select('*')
        .eq('category', category);

    return List<Map<String, dynamic>>.from(response);
  }

  List<Map<String,dynamic>> getRandomArticles(List<Map<String,dynamic>> articles) {
    final shuffled = List<Map<String,dynamic>>.from(articles)..shuffle(Random());
    return shuffled.take(2).toList();
  }

  @override
  Widget build(BuildContext context) {
    final categoryInfo = categoryInfoMap[widget.category]!;
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
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: _categoryArticles,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final articles = snapshot.data!;
                            if (articles.isEmpty) {
                              return const Center(
                                child: Text('No articles available'),
                              );
                            }
                            final randomArticles = getRandomArticles(articles);
                            return Column(
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
                            );
                          },
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