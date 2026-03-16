import 'package:flutter/material.dart';

Color getCategoryColor(int categoryId) {
    const colors = [
      Colors.orange,
      Colors.blue,
      Colors.purple,
      Colors.green,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.amber,
      Colors.cyan,
      Colors.deepPurple,
      Colors.lightGreen,
      Colors.deepOrange,
      Colors.brown,
      Colors.lime,
    ];

    if (categoryId <= 0) return Colors.grey;

    return colors[(categoryId - 1) % colors.length];
}
