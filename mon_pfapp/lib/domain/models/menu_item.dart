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

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json['id']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      icon: iconFromKey(json['icon']?.toString()),
      color: colorFromHex(json['color']?.toString(), const Color(0xFFE53935)),
    );
  }
}

class MenuItem {
  final String id;
  final String name;
  final String category;
  final String description;
  final String imageAsset;
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
    required this.imageAsset,
    required this.price,
    required this.rating,
    required this.prepTime,
    required this.icon,
    required this.color,
    this.vegetarian = false,
    this.popular = false,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';

    return MenuItem(
      id: id,
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? 'plats',
      description: json['description']?.toString() ?? '',
      imageAsset:
          json['imageAsset']?.toString() ??
          json['image_asset']?.toString() ??
          'assets/menu/$id.jpg',
      price: intFromJson(json['price']),
      rating: doubleFromJson(json['rating'], fallback: 4.5),
      prepTime:
          json['prepTime']?.toString() ??
          '${intFromJson(json['prepTimeMinutes'], fallback: 20)} min',
      icon: iconFromKey(json['icon']?.toString()),
      color: colorFromHex(json['color']?.toString(), const Color(0xFFE53935)),
      vegetarian: boolFromJson(json['vegetarian']),
      popular: boolFromJson(json['popular']),
    );
  }
}

int intFromJson(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.round();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

double doubleFromJson(dynamic value, {double fallback = 0}) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? fallback;
}

bool boolFromJson(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  final normalized = value?.toString().toLowerCase();
  return normalized == 'true' || normalized == '1' || normalized == 'yes';
}

Color colorFromHex(String? value, Color fallback) {
  if (value == null || value.trim().isEmpty) return fallback;

  final normalized = value.replaceFirst('#', '').trim();
  final hex = normalized.length == 6 ? 'FF$normalized' : normalized;
  final parsed = int.tryParse(hex, radix: 16);

  return parsed == null ? fallback : Color(parsed);
}

IconData iconFromKey(String? key) {
  return switch (key) {
    'soup_kitchen_outlined' => Icons.soup_kitchen_outlined,
    'restaurant_menu' => Icons.restaurant_menu,
    'set_meal_outlined' => Icons.set_meal_outlined,
    'cake_outlined' => Icons.cake_outlined,
    'local_cafe_outlined' => Icons.local_cafe_outlined,
    'breakfast_dining_outlined' => Icons.breakfast_dining_outlined,
    'dinner_dining' => Icons.dinner_dining,
    'lunch_dining' => Icons.lunch_dining,
    'eco_outlined' => Icons.eco_outlined,
    'bakery_dining_outlined' => Icons.bakery_dining_outlined,
    'local_drink_outlined' => Icons.local_drink_outlined,
    _ => Icons.restaurant_menu,
  };
}
