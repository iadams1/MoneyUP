import 'package:flutter/material.dart';
import 'package:moneyup/features/education/screens/articledetails.dart';
import 'category_helper.dart';

class ArticleCard extends StatelessWidget {
  final Map<String, dynamic> article;

  const ArticleCard({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    final style = CategoryHelper.getCategoryStyle(article['category'] ?? '');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(200),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(16, 0, 0, 0),
                offset: Offset(0, 8),
                blurRadius: 12,
              ),
            ],
          ),
          height: 85,
          width: 380,
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: Row(
              children: [
                // Category Icon
                Container(
                  height: 80,
                  width: 66,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: style.color,
                  ),
                  child: Image.asset(style.imageAsset),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Article title
                      Text(
                        article['display_title'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          height: 1.1,
                          color: Colors.black,
                        ),
                      ),
                      // Artile author
                      Text(
                        article['source_author'] ?? article['source_name'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  icon: Image.asset('assets/icons/chevronRightArrow.png'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ArticleDetailsScreen(articleId: article['id']),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}