import 'package:flutter/material.dart';

import 'package:mon_pfapp/domain/models/order_model.dart';
import 'package:mon_pfapp/features/client/data/order_service.dart';
import 'package:mon_pfapp/shared/widgets/app_ui.dart';

class DriverDashboardScreen extends StatefulWidget {
  final ValueChanged<String> onNavigate;

  const DriverDashboardScreen({super.key, required this.onNavigate});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  bool _online = true;
  bool _loading = true;
  final Set<String> _acceptedOrders = {};
  List<OrderModel> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final orders = await OrderService.fetchDriverOrders();

    if (!mounted) return;
    setState(() {
      _orders = orders;
      _loading = false;
    });
  }

  Future<void> _accept(OrderModel order) async {
    await OrderService.acceptForDelivery(order);

    if (!mounted) return;
    setState(() => _acceptedOrders.add(order.id));
    await _loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          RedHeader(
            title: 'Livreur',
            subtitle: _online ? 'Disponible pour livraison' : 'Indisponible',
            leading: IconButton.filled(
              onPressed: () => widget.onNavigate('home'),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.18),
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.arrow_back_rounded),
              tooltip: 'Retour',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _online ? 'En ligne' : 'Hors ligne',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Switch(
                  value: _online,
                  onChanged: (value) => setState(() => _online = value),
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppColors.success,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        label: 'Livraisons',
                        value: '12',
                        icon: Icons.inventory_2_outlined,
                        color: AppColors.red,
                        helper: 'Aujourd hui',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        label: 'Gains',
                        value: '4 200 DA',
                        icon: Icons.trending_up_rounded,
                        color: AppColors.success,
                        helper: '+8%',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        label: 'Km parcourus',
                        value: '38 km',
                        icon: Icons.navigation_outlined,
                        color: AppColors.blue,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        label: 'Temps moyen',
                        value: '22 min',
                        icon: Icons.schedule_rounded,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SurfaceCard(
                  padding: EdgeInsets.zero,
                  child: Container(
                    height: 150,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE8ECEF), Color(0xFFF9F9F9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          color: AppColors.mutedText,
                          size: 42,
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Zone de livraison - Alger Centre',
                          style: TextStyle(color: AppColors.mutedText),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(
                      child: SectionTitle(title: 'Nouvelles commandes'),
                    ),
                    StatusPill(
                      label: _orders.length.toString(),
                      color: AppColors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_loading)
                  const Center(child: CircularProgressIndicator())
                else if (_orders.isEmpty)
                  const SurfaceCard(
                    child: Text(
                      'Aucune commande disponible pour livraison.',
                      style: TextStyle(color: AppColors.mutedText),
                    ),
                  )
                else
                  ..._orders.map((order) {
                    final accepted =
                        _acceptedOrders.contains(order.id) ||
                        order.status.toLowerCase() == 'en route';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SurfaceCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    order.id,
                                    style: const TextStyle(
                                      color: AppColors.text,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                Text(
                                  formatDa(order.amount),
                                  style: const TextStyle(
                                    color: AppColors.red,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${order.client} - ${order.itemsCount} articles',
                              style: const TextStyle(
                                color: AppColors.mutedText,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  color: AppColors.red,
                                  size: 15,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    order.address,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.mutedText,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              '1.4 km - 8 min',
                              style: TextStyle(
                                color: AppColors.mutedText,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (accepted)
                              Row(
                                children: [
                                  const Expanded(
                                    child: StatusPill(
                                      label: 'Acceptee',
                                      color: AppColors.success,
                                    ),
                                  ),
                                  IconButton.filledTonal(
                                    onPressed: () {},
                                    icon: const Icon(Icons.phone_rounded),
                                    tooltip: 'Appeler le client',
                                  ),
                                ],
                              )
                            else
                              Row(
                                children: [
                                  Expanded(
                                    child: PrimaryButton(
                                      label: 'Accepter',
                                      icon: Icons.check_rounded,
                                      onPressed: _online
                                          ? () => _accept(order)
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                      ),
                                      child: const Text('Refuser'),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
