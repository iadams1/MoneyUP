import 'package:flutter/material.dart';

class CardGradients {
  CardGradients._();

  static List<LinearGradient> kCardGradients = [
     const LinearGradient(
      colors: [
        Color.fromARGB(255, 120, 6, 61), 
        Color.fromARGB(255, 215, 90, 0)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [
        Color(0xFF117860), 
        Color(0xFF000000)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [
        Color.fromARGB(255, 33, 66, 81), 
        Color.fromARGB(255, 133, 138, 176)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [
        Color.fromARGB(255, 54, 23, 81), 
        Color(0xFF4A00E0)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [
        Color(0xFF56CCF2), 
        Color(0xFF2F80ED)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [
        Color.fromARGB(255, 162, 157, 52), 
        Color.fromARGB(255, 47, 237, 132)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [
        Color.fromARGB(255, 225, 129, 247),
        Color.fromARGB(255, 142, 42, 139)], 
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];

  static LinearGradient gradientForCardId(int cardId) {
    final idx = cardId.abs() % kCardGradients.length;
    return kCardGradients[idx];
  }
}