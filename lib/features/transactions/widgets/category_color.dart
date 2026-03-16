import 'package:flutter/material.dart';

class CategoryColor {
  final Color backgroundColor;
  final Color textColor;

  const CategoryColor({
    required this.backgroundColor,
    required this.textColor,
  });
}

const CategoryColor defaultColor = CategoryColor(
  backgroundColor: Color(0xFFD6D6D6), 
  textColor: Colors.black,
);

final Map<String, CategoryColor> categoryColors = {
  'FOOD_AND_DRINK': CategoryColor(
    backgroundColor: Colors.orange,
    textColor: Colors.white,
  ),
  'GENERAL_MERCHANDISE': CategoryColor(
    backgroundColor: Colors.blue,
    textColor: Colors.white,
  ),
  'GENERAL_SERVICES': CategoryColor(
    backgroundColor: Colors.purple,
    textColor: Colors.white,
  ),
  'PERSONAL_CARE': CategoryColor(
    backgroundColor: Colors.green,
    textColor: Colors.white,
  ),
  'TRANSPORTATION': CategoryColor(
    backgroundColor: Colors.red,
    textColor: Colors.white,
  ),
  'ENTERTAINMENT': CategoryColor(
    backgroundColor: Colors.teal,
    textColor: Colors.white,
  ),
  'TRAVEL': CategoryColor(
    backgroundColor: Colors.indigo,
    textColor: Colors.white,
  ),
  'TRANSFER_IN': CategoryColor(
    backgroundColor: Colors.pink,
    textColor: Colors.white,
  ),
  'TRANSFER_OUT': CategoryColor(
    backgroundColor: Colors.amber,
    textColor: Colors.white,
  ),
  'BANK_FEES': CategoryColor(
    backgroundColor: Colors.cyan,
    textColor: Colors.white,
  ),
  'LOAN_PAYMENTS': CategoryColor(
    backgroundColor: Colors.deepPurple,
    textColor: Colors.white,
  ),
  'LOAN_DISBURSEMENTS': CategoryColor(
    backgroundColor:Colors.lightGreen,
    textColor: Colors.white,
  ),
  'MEDICAL': CategoryColor(
    backgroundColor: Colors.deepOrange,
    textColor: Colors.white,
  ),
  'INCOME': CategoryColor(
    backgroundColor: Colors.brown,
    textColor: Colors.white,
  ),
  'GOVERNMENT_AND_NON_PROFIT': CategoryColor(
    backgroundColor: Colors.lime,
    textColor: Colors.white,
  ),
  'RENT_AND_UTILITIES': CategoryColor(
    backgroundColor: const Color.fromARGB(255, 70, 181, 127),
    textColor: Colors.white,
  ),
};