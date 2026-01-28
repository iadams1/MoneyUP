import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../education/widgets/article_card.dart';
import '../loading.dart';
import '../education/education.dart';
import '../main.dart';
import '../profile.dart';
import '../transactions/transactions_home.dart';

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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _categoryArticles,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return LoadingScreen();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Image.asset('assets/icons/chevronLeftArrow.png'),
                          onPressed: () {
                          Navigator.pop(context);
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.category,
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontSize: 34,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Why it Matters',
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontSize: 20,
                            fontStyle: FontStyle.italic
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Best Practices',
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontSize: 20,
                          ),
                        ),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: _categoryArticles,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const LoadingScreen();
                            }
                            final articles = snapshot.data!;
                            if (articles.isEmpty) {
                              return const Text(
                                'No articles available.',
                              );
                            }
                            return Column(
                              spacing: 15,
                              children: articles.map((a) => ArticleCard(article: a,)).toList(),
                            );
                          },
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