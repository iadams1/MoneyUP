import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

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
  'Food & Drink': CategoryColor(
    backgroundColor: HexColor('#C40418'),
    textColor: Colors.white,
  ),
  'Entertainment': CategoryColor(
    backgroundColor: HexColor('#F29D13'),
    textColor: Colors.white,
  ),
  'Travel': CategoryColor(
    backgroundColor: HexColor('#D11D62'),
    textColor: Colors.white,
  ),
  'Transportation': CategoryColor(
    backgroundColor: HexColor('#33B5CC'),
    textColor: Colors.white,
  ),
  'Personal Care': CategoryColor(
    backgroundColor: HexColor('#B532CF'),
    textColor: Colors.white,
  ),
  'General Merchandise': CategoryColor(
    backgroundColor: HexColor('#1DB44F'),
    textColor: Colors.white,
  ),
};