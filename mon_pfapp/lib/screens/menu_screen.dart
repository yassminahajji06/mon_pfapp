import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../models/menu_item.dart';
import '../widgets/app_ui.dart';

class MenuScreen extends StatefulWidget {
  final int cartCount;
  final ValueChanged<String> onNavigate;
  final ValueChanged<MenuItem> onAddToCart;

  const MenuScreen({
    super.key,
    required this.cartCount,
    required this.onNavigate,
    required this.onAddToCart,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _category = 'plats';
  String _query = '';

  List<MenuItem> get _items {
    return DemoData.menuItems.where((item) {
      final matchesCategory = item.category == _category;
      final query = _query.trim().toLowerCase();
      final matchesQuery = query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Menu du restaurant'),
        leading: IconButton(
          onPressed: () => widget.onNavigate('home'),
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Retour',
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Filtres',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: 'Rechercher dans le menu...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: const Color(0xFFF4F4F4),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: DemoData.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = DemoData.categories[index];
                      final selected = category.id == _category;
                      return ChoiceChip(
                        selected: selected,
                        label: Text(category.label),
                        avatar: Icon(
                          category.icon,
                          size: 17,
                          color: selected ? Colors.white : category.color,
                        ),
                        selectedColor: AppColors.red,
                        backgroundColor: const Color(0xFFF4F4F4),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : AppColors.text,
                          fontWeight: FontWeight.w800,
                        ),
                        side: BorderSide.none,
                        onSelected: (_) => setState(() => _category = category.id),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _items.isEmpty
                ? const Center(
                    child: Text(
                      'Aucun plat trouve',
                      style: TextStyle(color: AppColors.mutedText),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return MenuItemCard(
                        item: item,
                        onAdd: () => widget.onAddToCart(item),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        active: 'menu',
        cartCount: widget.cartCount,
        onNavigate: widget.onNavigate,
      ),
    );
  }
}
