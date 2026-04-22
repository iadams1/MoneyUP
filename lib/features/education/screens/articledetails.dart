import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '/models/article.dart';
import '/services/service_locator.dart';
import '/shared/screen/loading_screen.dart';
import '/shared/widgets/app_avatar.dart';
import '/shared/utils/show_notification_dashboard.dart';
import '/shared/widgets/bottom_nav.dart';
import '/shared/widgets/error_system.dart';

class ArticleDetailsScreen extends StatefulWidget {
  final int articleId;

  const ArticleDetailsScreen({super.key, required this.articleId});

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  late final ScrollController _summaryScrollController;
  bool _isLoading = true;
  Article? _article;

  @override
  void initState() {
    super.initState();
    _loadArticle();
    _summaryScrollController = ScrollController();
  }

  Future<void> _loadArticle() async {
    try {
      final article = await articleService.getArticleById(widget.articleId);
      if (!mounted) return;

      setState(() {
        _article = article;
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
  void dispose() {
    _summaryScrollController.dispose();
    super.dispose();
  }

  Future<void> openArticleUrl(String url) async {
    final Uri uri = Uri.parse(url.trim());

    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        showDialog(
          context: context,
          builder: (_) => ErrorDialog(
            message: 'Could not open the link.',
            onButtonPressed: () => Navigator.pop(context),
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => ErrorDialog(
          message: 'Error opening link: $e',
          onButtonPressed: () => Navigator.pop(context),
        ),
      );
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
    final article = _article!;

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
              AppAvatar(size: 60),
              Container(
                // NOTIFICATION ICON
                alignment: Alignment.topRight,
                padding: EdgeInsets.all(5),
                child: IconButton(
                  onPressed: () {
                    showNotificationDropdown(context);
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
        toolbarHeight: 130,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            article.displayTitle,
                            style: const TextStyle(
                              fontSize: 30,
                              height: 1.1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 5),

                          // Author
                          Text(
                            article.displaySource,
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
                              onPressed: () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text(
                                      'View Full Article',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    content: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      'Do you want to view the full article?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  backgroundColor: Colors.white,
                                  actions: [
                                    Center(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
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
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                      255,
                                                      184,
                                                      27,
                                                      27,
                                                    ),
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              onPressed: () {
                                                // Proceed with going to an outside source
                                                openArticleUrl(article.sourceURL);
                                                Navigator.pop(context, true);
                                              },
                                              child: const Text(
                                                "View Article",
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
                                ),
                              );
                              if (confirmed != true) return;
                              openArticleUrl(article.sourceURL);
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
                                  width: 200,
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
                                  article.summary,
                                  style: const TextStyle(fontSize: 19),
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
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }
}