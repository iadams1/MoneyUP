import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


import 'package:moneyup/education/education.dart';
import 'package:moneyup/main.dart';
import 'package:moneyup/profile.dart';
import 'package:moneyup/transactions/transactions_home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class ArticleDetailsScreen extends StatefulWidget {
  final int articleId;

  const ArticleDetailsScreen({super.key, required this.articleId});

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  late Future<Map<String, dynamic>> _detailedArticle;
  late final ScrollController _summaryScrollController;

  @override
  void initState() {
    super.initState();
    _detailedArticle = getArticleById(widget.articleId);
    _summaryScrollController = ScrollController();
  }

  @override
  void dispose() {
    _summaryScrollController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> getArticleById(int id) async {
    final response = await Supabase.instance.client
        .from('Educational')
        .select('*')
        .eq('id', id)
        .single();

    return Map<String, dynamic>.from(response);
  }

  Future<void> openArticleUrl(String url) async {
    final Uri uri = Uri.parse(url.trim());

    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open the link.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening link: $e')),
      );
    }
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: FutureBuilder<Map<String, dynamic>>(
                        future: _detailedArticle,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final article = snapshot.data!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                article['display_title'],
                                style: const TextStyle(
                                  fontSize: 30,
                                  height: 1.1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 5),

                              // Author
                              Text(
                                article['source_author'] ??
                                    article['source_name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 10),

                              // View Full Article Button
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(200),
                                    ),
                                  ),
                                  onPressed: () {
                                    openArticleUrl(article['source_url']);
                                  },
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromRGBO(25, 50, 100, 1),
                                          Color.fromRGBO(47, 52, 126, 1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(200),
                                    ),
                                    child: const SizedBox(
                                      width: 230,
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                          'View Full Article',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 15),

                              const Text(
                                "Summary",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 5),

                              // Summary Box
                              Expanded(
                                child: RawScrollbar(
                                  controller: _summaryScrollController,
                                  thumbVisibility: true,
                                  radius: const Radius.circular(10),
                                  thickness: 5,
                                  thumbColor: Color.fromRGBO(47, 52, 126, 100),
                                  child: SingleChildScrollView(
                                    controller: _summaryScrollController,
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.only(
                                      right: 16,
                                      bottom: 8,
                                    ),
                                    child: Text(
                                      article['summary'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 19
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
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
