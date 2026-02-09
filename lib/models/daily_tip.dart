class DailyTip {
  final int articleId;
  final String tipSummary;
  final String displayTitle;

  DailyTip({
    required this.articleId,
    required this.tipSummary,
    required this.displayTitle,
  });

  factory DailyTip.fromJson(Map<String, dynamic> json) {
    return DailyTip(
      articleId: json["id"],
      tipSummary: (json["tip_summary"] ?? '') as String, 
      displayTitle: (json["display_title"] ?? '') as String,
    );
  }
}