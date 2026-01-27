import 'package:flutter/material.dart';

class CategoryStyle {
  final Color color;
  final String imageAsset;

  const CategoryStyle({required this.color, required this.imageAsset});
}

class CategoryHelper {
  static const Map<String, CategoryStyle> _categoryStyles = {
    'Budgeting': CategoryStyle(
      color: Color.fromRGBO(206, 235, 181, 100),
      imageAsset: 'assets/icons/articleBudgeting.png',
    ),
    'Credit': CategoryStyle(
      color: Color.fromRGBO(191, 240, 241, 100),
      imageAsset: 'assets/icons/articleCredit.png',
    ),
    'Debt': CategoryStyle(
      color: Color.fromRGBO(255, 222, 175, 100),
      imageAsset: 'assets/icons/articleDebt.png',
    ),
    'Savings': CategoryStyle(
      color: Color.fromRGBO(241, 191, 228, 100),
      imageAsset: 'assets/icons/articleSavings.png',
    ),
    'Banking': CategoryStyle(
      color: Color.fromRGBO(223, 191, 236, 100),
      imageAsset: 'assets/icons/articleBanking.png',
    ),
    'Investing': CategoryStyle(
      color: Color.fromRGBO(247, 249, 179, 100),
      imageAsset: 'assets/icons/articleInvesting.png',
    ),
  };

  static final List<String> categories = _categoryStyles.keys.toList();

  static CategoryStyle getCategoryStyle(String category) {
    return _categoryStyles[category] ??
        const CategoryStyle(
          color: Colors.grey,
          imageAsset: 'assets/icons/default.png',
        );
  }
}
