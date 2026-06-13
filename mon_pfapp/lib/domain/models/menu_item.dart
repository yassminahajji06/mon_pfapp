import 'package:flutter/material.dart';

class MenuCategory {
  final String id;
  final String label;
  final IconData icon;
  final Color color;

  const MenuCategory({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
  });
}

class MenuItem {
  final String id;
  final String name;
  final String category;
  final String description;
  final int price;
  final double rating;
  final String prepTime;
  final IconData icon;
  final Color color;
  final bool vegetarian;
  final bool popular;

  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.rating,
    required this.prepTime,
    required this.icon,
    required this.color,
    this.vegetarian = false,
    this.popular = false,
  });
}
