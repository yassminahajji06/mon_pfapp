import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../widgets/app_ui.dart';

class AdminDashboardScreen extends StatefulWidget {
  final ValueChanged<String> onNavigate;

  const AdminDashboardScreen({super.key, required this.onNavigate});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _tab = 'apercu';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          RedHeader(
            title: 'Administration',
            subtitle: 'Tableau de bord',
            leading: IconButton.filled(
              onPressed: () => widget.onNavigate('home'),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.18),
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.arrow_back_rounded),
              tooltip: 'Retour',
            ),
            trailing: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'apercu', label: Text('Apercu'), icon: Icon(Icons.dashboard_outlined)),
                ButtonSegment(value: 'commandes', label: Text('Commandes'), icon: Icon(Icons.receipt_long_outlined)),
                ButtonSegment(value: 'equipe', label: Text('Equipe'), icon: Icon(Icons.groups_outlined)),
              ],
              selected: {_tab},
              showSelectedIcon: false,
              onSelectionChanged: (value) => setState(() => _tab = value.first),
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor: AppColors.red,
                selectedForegroundColor: Colors.white,
                foregroundColor: AppColors.text,
              ),
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: switch (_tab) {
                'commandes' => _OrdersAdminTab(key: const ValueKey('commandes')),
                'equipe' => const _TeamAdminTab(key: ValueKey('equipe')),
                _ => const _OverviewAdminTab(key: ValueKey('apercu')),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewAdminTab extends StatelessWidget {
  const _OverviewAdminTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'CA du jour',
                value: '402 000 DA',
                icon: Icons.trending_up_rounded,
                color: AppColors.red,
                helper: '+12%',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: StatCard(
                label: 'Commandes',
                value: '47',
                icon: Icons.inventory_2_outlined,
                color: AppColors.blue,
                helper: '+8',
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'Clients actifs',
                value: '134',
                icon: Icons.people_alt_outlined,
                color: AppColors.success,
                helper: '+5%',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: StatCard(
                label: 'Livreurs',
                value: '6 / 8',
                icon: Icons.delivery_dining_rounded,
                color: AppColors.warning,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        _RevenueCard(),
        SizedBox(height: 16),
        SurfaceCard(
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.warning),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Stock faible : Coq au Vin, seulement 3 portions disponibles.',
                  style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RevenueCard extends StatelessWidget {
  const _RevenueCard();

  @override
  Widget build(BuildContext context) {
    final values = [42, 38, 51, 47, 68, 82, 74];
    final days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: "Chiffre d'affaires"),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < values.length; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: FractionallySizedBox(
                                heightFactor: values[i] / 90,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(days[i], style: const TextStyle(color: AppColors.mutedText, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdersAdminTab extends StatelessWidget {
  const _OrdersAdminTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: DemoData.recentOrders.map((order) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SurfaceCard(
            child: Row(
              children: [
                const Icon(Icons.receipt_long_rounded, color: AppColors.red),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.id, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w900)),
                      Text(order.client, style: const TextStyle(color: AppColors.mutedText, fontSize: 12)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(formatDa(order.amount), style: const TextStyle(color: AppColors.red, fontWeight: FontWeight.w900)),
                    Text(order.status, style: const TextStyle(color: AppColors.mutedText, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _TeamAdminTab extends StatelessWidget {
  const _TeamAdminTab({super.key});

  @override
  Widget build(BuildContext context) {
    final members = const [
      ('Karim B.', 'Livreur', 'En ligne', '4.9'),
      ('Amira S.', 'Cuisiniere', 'En ligne', '4.8'),
      ('Nassim R.', 'Livreur', 'Hors ligne', '4.7'),
      ('Fatima L.', 'Service client', 'En ligne', '5.0'),
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: members.map((member) {
        final online = member.$3 == 'En ligne';
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SurfaceCard(
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFEBEE),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        member.$1.split(' ').map((part) => part[0]).join(),
                        style: const TextStyle(color: AppColors.red, fontWeight: FontWeight.w900),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                          color: online ? AppColors.success : AppColors.mutedText,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(member.$1, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w900)),
                      Text('${member.$2} - ${member.$3}', style: const TextStyle(color: AppColors.mutedText, fontSize: 12)),
                    ],
                  ),
                ),
                Text('Note ${member.$4}', style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
