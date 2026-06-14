import 'package:flutter/material.dart';

import 'package:mon_pfapp/domain/models/menu_item.dart';
import 'package:mon_pfapp/domain/models/user_model.dart';
import 'package:mon_pfapp/shared/widgets/app_ui.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;
  final int cartCount;
  final List<MenuCategory> categories;
  final List<MenuItem> menuItems;
  final ValueChanged<String> onNavigate;
  final ValueChanged<MenuItem> onAddToCart;

  const HomeScreen({
    super.key,
    required this.user,
    required this.cartCount,
    required this.categories,
    required this.menuItems,
    required this.onNavigate,
    required this.onAddToCart,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'plats';

  List<MenuItem> get _popularItems {
    final byCategory = widget.menuItems
        .where((item) => item.category == _selectedCategory)
        .toList();
    return byCategory.isEmpty
        ? widget.menuItems.where((item) => item.popular).toList()
        : byCategory;
  }

  @override
  Widget build(BuildContext context) {
    final firstName = widget.user.nom.split(' ').first;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
            decoration: const BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFFFFCDD2),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      const Expanded(
                        child: Text(
                          'Alger Centre',
                          style: TextStyle(
                            color: Color(0xFFFFCDD2),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      IconButton.filled(
                        onPressed: () {},
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.18),
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.notifications_none_rounded),
                        tooltip: 'Notifications',
                      ),
                    ],
                  ),
                  Text(
                    'Bonjour, $firstName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    readOnly: true,
                    onTap: () => widget.onNavigate('menu'),
                    decoration: InputDecoration(
                      hintText: 'Rechercher un plat...',
                      hintStyle: const TextStyle(color: AppColors.mutedText),
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              children: [
                _PromoBanner(onTap: () => widget.onNavigate('menu')),
                const SizedBox(height: 22),
                const SectionTitle(title: 'Categories'),
                const SizedBox(height: 10),
                SizedBox(
                  height: 92,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final category = widget.categories[index];
                      final selected = _selectedCategory == category.id;
                      return InkWell(
                        onTap: () =>
                            setState(() => _selectedCategory = category.id),
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 86,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.red : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                category.icon,
                                color: selected ? Colors.white : category.color,
                                size: 25,
                              ),
                              const SizedBox(height: 7),
                              Text(
                                category.label,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : AppColors.text,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SectionTitle(
                  title: 'Plats populaires',
                  actionLabel: 'Voir tout',
                  onAction: () => widget.onNavigate('menu'),
                ),
                const SizedBox(height: 8),
                ..._popularItems
                    .take(3)
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: MenuItemCard(
                          item: item,
                          onTap: () => widget.onNavigate('menu'),
                          onAdd: () => widget.onAddToCart(item),
                        ),
                      ),
                    ),
                const SizedBox(height: 8),
                const SectionTitle(title: 'Espaces de demonstration'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _DemoAccessCard(
                        label: 'Livreur',
                        icon: Icons.delivery_dining_rounded,
                        color: AppColors.blue,
                        onTap: () => widget.onNavigate('driver'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DemoAccessCard(
                        label: 'Admin',
                        icon: Icons.admin_panel_settings_rounded,
                        color: AppColors.warning,
                        onTap: () => widget.onNavigate('admin'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        active: 'home',
        cartCount: widget.cartCount,
        onNavigate: widget.onNavigate,
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _PromoBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.darkRed,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Offre du jour',
                    style: TextStyle(
                      color: Color(0xFFFFCDD2),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '-20% sur les menus du soir',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 10),
                  StatusPill(label: 'Commander', color: Colors.white),
                ],
              ),
            ),
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.local_dining_rounded,
                color: Colors.white,
                size: 44,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoAccessCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DemoAccessCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.mutedText),
        ],
      ),
    );
  }
}
