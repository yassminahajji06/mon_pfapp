import 'package:flutter/material.dart';

import 'package:mon_pfapp/domain/models/order_model.dart';
import 'package:mon_pfapp/shared/widgets/app_ui.dart';

class OrdersScreen extends StatelessWidget {
  final int cartCount;
  final List<OrderModel> orders;
  final bool loading;
  final ValueChanged<String> onNavigate;
  final Future<void> Function() onRefresh;

  const OrdersScreen({
    super.key,
    required this.cartCount,
    required this.orders,
    required this.loading,
    required this.onNavigate,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final activeOrders = orders
        .where((order) => order.status.toLowerCase() != 'livre')
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mes Commandes'),
        actions: [
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : orders.isEmpty
            ? ListView(
                padding: const EdgeInsets.all(24),
                children: const [
                  SizedBox(height: 140),
                  Icon(
                    Icons.receipt_long_outlined,
                    color: AppColors.mutedText,
                    size: 58,
                  ),
                  SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Aucune commande pour le moment',
                      style: TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              )
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  if (activeOrders.isNotEmpty) ...[
                    _ActiveOrderCard(
                      order: activeOrders.first,
                      onTrack: () => onNavigate('tracking'),
                    ),
                    const SizedBox(height: 18),
                  ],
                  const SectionTitle(title: 'Historique'),
                  const SizedBox(height: 10),
                  ...orders.map(
                    (order) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _OrderHistoryCard(
                        order: order,
                        statusColor: _statusColor(order.status),
                      ),
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: AppBottomNav(
        active: 'orders',
        cartCount: cartCount,
        onNavigate: onNavigate,
      ),
    );
  }

  Color _statusColor(String status) {
    return switch (status.toLowerCase()) {
      'livre' => AppColors.success,
      'pret' => AppColors.warning,
      'en route' => AppColors.blue,
      'preparation' => AppColors.warning,
      _ => AppColors.mutedText,
    };
  }
}

class _ActiveOrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTrack;

  const _ActiveOrderCard({required this.order, required this.onTrack});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.red.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.delivery_dining_rounded,
              color: AppColors.red,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Commande en cours',
                  style: TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${order.id} - ${order.status}',
                  style: const TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onTrack,
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: const Text('Suivre'),
          ),
        ],
      ),
    );
  }
}

class _OrderHistoryCard extends StatelessWidget {
  final OrderModel order;
  final Color statusColor;

  const _OrderHistoryCard({required this.order, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.receipt_long_rounded, color: statusColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.id,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${order.time} - ${order.address}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatDa(order.amount),
                style: const TextStyle(
                  color: AppColors.red,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                order.status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
