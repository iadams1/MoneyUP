import 'package:flutter/material.dart';
import 'package:moneyup/features/education/screens/education.dart';
import 'package:moneyup/features/proflie/screens/profile.dart';
import 'package:moneyup/features/transactions/screens/transactions_home.dart';

import 'package:moneyup/main.dart';
import 'package:moneyup/shared/widgets/article_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewAllArticlesScreen extends StatefulWidget {
  const ViewAllArticlesScreen({super.key});

  @override
  State<ViewAllArticlesScreen> createState() => _ViewAllArticlesScreenState();
}

class _ViewAllArticlesScreenState extends State<ViewAllArticlesScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = getAllArticles();
  }

  Future<List<Map<String, dynamic>>> getAllArticles() async {
    final response = await Supabase.instance.client
        .from('Educational')
        .select('*')        
        .order('created_at', ascending: false); 

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Back Button
                        IconButton(
                          icon: Image.asset(
                            'assets/icons/chevronLeftArrow.png',
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),

                        Text(
                          "All Articles",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 5)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: _future,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final articles = snapshot.data!;
                          if (articles.isEmpty) {
                            return const Center(child: Text('No articles available.'));
                          }

                          return ListView.separated(
                            itemCount: articles.length,
                            itemBuilder: (context, index) => ArticleCard(article: articles[index]),
                            separatorBuilder: (context, index) => const SizedBox(height: 10),
                          );
                        },
                      )
                    )
                  )
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

  
