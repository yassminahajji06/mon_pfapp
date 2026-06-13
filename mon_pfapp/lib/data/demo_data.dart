import 'package:flutter/material.dart';

import 'package:mon_pfapp/domain/models/menu_item.dart';
import 'package:mon_pfapp/domain/models/order_model.dart';
import 'package:mon_pfapp/domain/models/user_model.dart';

class DemoData {
  static final demoUser = UserModel(
    id: 1,
    nom: 'Yassmine Hajji',
    email: 'yassmine@monpf.fr',
    role: 'client',
  );

  static const categories = [
    MenuCategory(
      id: 'entrees',
      label: 'Entrees',
      icon: Icons.soup_kitchen_outlined,
      color: Color(0xFFFB8C00),
    ),
    MenuCategory(
      id: 'plats',
      label: 'Plats',
      icon: Icons.restaurant_menu,
      color: Color(0xFFE53935),
    ),
    MenuCategory(
      id: 'poissons',
      label: 'Poissons',
      icon: Icons.set_meal_outlined,
      color: Color(0xFF1E88E5),
    ),
    MenuCategory(
      id: 'desserts',
      label: 'Desserts',
      icon: Icons.cake_outlined,
      color: Color(0xFF8E24AA),
    ),
    MenuCategory(
      id: 'boissons',
      label: 'Boissons',
      icon: Icons.local_cafe_outlined,
      color: Color(0xFF43A047),
    ),
  ];

  static const menuItems = [
    MenuItem(
      id: 'soupe-oignon',
      name: "Soupe a l'oignon",
      category: 'entrees',
      description: 'Oignons confits, bouillon maison et fromage gratine.',
      price: 450,
      rating: 4.7,
      prepTime: '15 min',
      icon: Icons.soup_kitchen_outlined,
      color: Color(0xFFFB8C00),
    ),
    MenuItem(
      id: 'foie-gras',
      name: 'Foie gras maison',
      category: 'entrees',
      description: 'Servi avec confiture de figues et pain grille.',
      price: 780,
      rating: 4.9,
      prepTime: '12 min',
      icon: Icons.breakfast_dining_outlined,
      color: Color(0xFF795548),
      popular: true,
    ),
    MenuItem(
      id: 'coq-vin',
      name: 'Coq au Vin',
      category: 'plats',
      description: 'Poulet braise au vin rouge, champignons et carottes.',
      price: 890,
      rating: 4.8,
      prepTime: '25 min',
      icon: Icons.dinner_dining,
      color: Color(0xFFE53935),
      popular: true,
    ),
    MenuItem(
      id: 'boeuf-bourguignon',
      name: 'Boeuf Bourguignon',
      category: 'plats',
      description: 'Boeuf mijote, sauce riche et legumes fondants.',
      price: 1100,
      rating: 4.6,
      prepTime: '30 min',
      icon: Icons.lunch_dining,
      color: Color(0xFFB71C1C),
    ),
    MenuItem(
      id: 'ratatouille',
      name: 'Ratatouille',
      category: 'plats',
      description: 'Legumes du soleil, herbes de Provence et huile olive.',
      price: 680,
      rating: 4.5,
      prepTime: '20 min',
      icon: Icons.eco_outlined,
      color: Color(0xFF43A047),
      vegetarian: true,
    ),
    MenuItem(
      id: 'bouillabaisse',
      name: 'Bouillabaisse',
      category: 'poissons',
      description: 'Soupe provencale de poissons, rouille et croutons.',
      price: 1200,
      rating: 4.9,
      prepTime: '35 min',
      icon: Icons.set_meal_outlined,
      color: Color(0xFF1E88E5),
      popular: true,
    ),
    MenuItem(
      id: 'creme-brulee',
      name: 'Creme Brulee',
      category: 'desserts',
      description: 'Creme vanille et fine couche de caramel croquant.',
      price: 350,
      rating: 4.7,
      prepTime: '10 min',
      icon: Icons.cake_outlined,
      color: Color(0xFF8E24AA),
      vegetarian: true,
    ),
    MenuItem(
      id: 'tarte-tatin',
      name: 'Tarte Tatin',
      category: 'desserts',
      description: 'Pommes caramelisees et pate croustillante.',
      price: 320,
      rating: 4.8,
      prepTime: '10 min',
      icon: Icons.bakery_dining_outlined,
      color: Color(0xFFF57C00),
      vegetarian: true,
    ),
    MenuItem(
      id: 'citronnade',
      name: 'Citronnade maison',
      category: 'boissons',
      description: 'Citron frais, menthe et eau petillante.',
      price: 180,
      rating: 4.4,
      prepTime: '5 min',
      icon: Icons.local_drink_outlined,
      color: Color(0xFF43A047),
      vegetarian: true,
    ),
  ];

  static const recentOrders = [
    OrderModel(
      id: '#PF-0847',
      client: 'Yassmine H.',
      address: '12 Rue Didouche Mourad, Alger Centre',
      status: 'Livre',
      time: '14:32',
      amount: 2090,
    ),
    OrderModel(
      id: '#PF-0848',
      client: 'Sofia A.',
      address: "45 Rue Ben M'hidi, Alger",
      status: 'En route',
      time: '14:48',
      amount: 1890,
    ),
    OrderModel(
      id: '#PF-0849',
      client: 'Rami K.',
      address: '12 Bd Zighout Youcef, Bab El Oued',
      status: 'Preparation',
      time: '15:00',
      amount: 980,
    ),
  ];
}
