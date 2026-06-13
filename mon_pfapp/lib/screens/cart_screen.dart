import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../widgets/app_ui.dart';

class CartScreen extends StatelessWidget {
  final List<CartItem> items;
  final ValueChanged<String> onNavigate;
  final ValueChanged<CartItem> onIncrease;
  final ValueChanged<CartItem> onDecrease;
  final ValueChanged<CartItem> onRemove;
  final VoidCallback onCheckout;

  const CartScreen({
    super.key,
    required this.items,
    required this.onNavigate,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
    required this.onCheckout,
  });

  int get subtotal => items.fold(0, (sum, item) => sum + item.total);
  int get delivery => items.isEmpty ? 0 : 150;
  int get total => subtotal + delivery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Mon Panier (${items.length})'),
        leading: IconButton(
          onPressed: () => onNavigate('menu'),
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Retour',
        ),
      ),
      body: items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shopping_cart_outlined, color: AppColors.mutedText, size: 62),
                    const SizedBox(height: 12),
                    const Text(
                      'Votre panier est vide',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.text),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ajoutez des plats depuis le menu pour tester la commande.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.mutedText),
                    ),
                    const SizedBox(height: 18),
                    PrimaryButton(
                      label: 'Voir le menu',
                      icon: Icons.restaurant_menu_rounded,
                      onPressed: () => onNavigate('menu'),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ...items.map(
                  (cartItem) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SurfaceCard(
                      child: Row(
                        children: [
                          FoodVisual(item: cartItem.item, size: 70),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartItem.item.name,
                                  style: const TextStyle(
                                    color: AppColors.text,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatDa(cartItem.item.price),
                                  style: const TextStyle(
                                    color: AppColors.red,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () => onRemove(cartItem),
                                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.mutedText),
                                tooltip: 'Supprimer',
                              ),
                              Row(
                                children: [
                                  _QtyButton(icon: Icons.remove, onTap: () => onDecrease(cartItem)),
                                  SizedBox(
                                    width: 30,
                                    child: Text(
                                      cartItem.quantity.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  _QtyButton(icon: Icons.add, onTap: () => onIncrease(cartItem), filled: true),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const _AddressCard(),
                const SizedBox(height: 12),
                SurfaceCard(
                  child: Row(
                    children: [
                      const Icon(Icons.local_offer_outlined, color: AppColors.mutedText),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Code promo',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(foregroundColor: AppColors.red),
                        child: const Text('Appliquer'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recapitulatif',
                        style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 14),
                      _SummaryRow(label: 'Sous-total', value: formatDa(subtotal)),
                      _SummaryRow(label: 'Livraison', value: formatDa(delivery)),
                      const _SummaryRow(label: 'Remise', value: '- 0 DA', positive: true),
                      const Divider(height: 22),
                      _SummaryRow(label: 'Total', value: formatDa(total), strong: true),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (items.isNotEmpty)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: PrimaryButton(
                label: 'Passer la commande - ${formatDa(total)}',
                icon: Icons.check_circle_outline_rounded,
                onPressed: onCheckout,
              ),
            ),
          AppBottomNav(
            active: 'cart',
            cartCount: items.fold(0, (sum, item) => sum + item.quantity),
            onNavigate: onNavigate,
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: filled ? AppColors.red : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, size: 16, color: filled ? Colors.white : AppColors.text),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard();

  @override
  Widget build(BuildContext context) {
    return const SurfaceCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.location_on_outlined, color: AppColors.red),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adresse de livraison',
                  style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 4),
                Text(
                  '12 Rue Didouche Mourad, Alger Centre',
                  style: TextStyle(color: AppColors.mutedText, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool strong;
  final bool positive;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.strong = false,
    this.positive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: strong ? AppColors.text : AppColors.mutedText,
                fontWeight: strong ? FontWeight.w900 : FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: positive ? AppColors.success : strong ? AppColors.red : AppColors.text,
              fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
