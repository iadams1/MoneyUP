import 'package:flutter/material.dart';

class CardGradients {
  CardGradients._();

  /// Map each gradient to a unique name
  static final Map<String, LinearGradient> kCardGradients = {
    'gradient_1': const LinearGradient(
      colors: [Color.fromARGB(255, 120, 6, 61), Color.fromARGB(255, 215, 90, 0)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'gradient_2': const LinearGradient(
      colors: [Color(0xFF117860), Color(0xFF000000)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'gradient_3': const LinearGradient(
      colors: [Color.fromARGB(255, 33, 66, 81), Color.fromARGB(255, 133, 138, 176)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'gradient_4': const LinearGradient(
      colors: [Color.fromARGB(255, 54, 23, 81), Color(0xFF4A00E0)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'gradient_5': const LinearGradient(
      colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'gradient_6': const LinearGradient(
      colors: [Color.fromARGB(255, 162, 157, 52), Color.fromARGB(255, 47, 237, 132)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'gradient_7': const LinearGradient(
      colors: [Color.fromARGB(255, 225, 129, 247), Color.fromARGB(255, 142, 42, 139)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  };

  // Get gradient by name from Supabase
  static LinearGradient fromName(String name) {
    return kCardGradients[name] ?? kCardGradients.values.first;
  }
}