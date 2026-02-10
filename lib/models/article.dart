class Article {
  final int articleId;

  final String originalTitle;
  final String displayTitle;

  final String category;
  final String summary;

  final String sourceName;
  final String sourceAuthor;
  final String sourceURL;

  Article({
    required this.articleId,
    required this.originalTitle,
    required this.displayTitle,
    required this.category,
    required this.summary,
    required this.sourceName,
    required this.sourceAuthor,
    required this.sourceURL,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      articleId: json["id"],
      originalTitle: (json["original_title"] ?? '') as String,
      displayTitle: (json["display_title"] ?? '') as String,
      category: (json["category"] ?? '') as String,
      summary: (json["summary"] ?? '') as String,
      sourceName: (json["source_name"] ?? '') as String,
      sourceAuthor: (json["source_author"] ?? '') as String,
      sourceURL: (json["source_url"] ?? '') as String,
    );
  }

  String get displaySource =>
      sourceAuthor.trim().isNotEmpty == true
          ? sourceAuthor
          : (sourceName);

}