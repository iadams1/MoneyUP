import 'package:flutter/material.dart';

Color getCategoryColor(int categoryID) {
    switch (categoryID) {
      case 1:
        return Colors.orange;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.green;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
