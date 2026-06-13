import 'package:flutter/material.dart';

import 'package:mon_pfapp/domain/models/user_model.dart';
import 'package:mon_pfapp/features/auth/data/auth_service.dart';
import 'package:mon_pfapp/shared/widgets/app_ui.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;
  final int cartCount;
  final ValueChanged<String> onNavigate;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.user,
    required this.cartCount,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifications = true;
  bool _loggingOut = false;

  Future<void> _logout() async {
    setState(() => _loggingOut = true);
    await AuthService.logout();
    if (!mounted) return;
    widget.onLogout();
  }

  @override
  Widget build(BuildContext context) {
    final initials = widget.user.nom
        .split(' ')
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0])
        .join()
        .toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            decoration: const BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4),
                        width: 4,
                      ),
                    ),
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.nom,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.user.email,
                          style: const TextStyle(
                            color: Color(0xFFFFCDD2),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const StatusPill(
                          label: 'Client Premium',
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                SurfaceCard(
                  child: Row(
                    children: const [
                      Expanded(
                        child: _ProfileStat(label: 'Commandes', value: '24'),
                      ),
                      SizedBox(
                        height: 44,
                        child: VerticalDivider(color: AppColors.border),
                      ),
                      Expanded(
                        child: _ProfileStat(label: 'Note moy.', value: '4.8'),
                      ),
                      SizedBox(
                        height: 44,
                        child: VerticalDivider(color: AppColors.border),
                      ),
                      Expanded(
                        child: _ProfileStat(
                          label: 'Fidelite',
                          value: '1240 pts',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionTitle(
                        title: 'Commandes recentes',
                        actionLabel: 'Tout voir',
                        onAction: () => widget.onNavigate('orders'),
                      ),
                      const _RecentOrder(
                        id: '#PF-0847',
                        date: '13 Juin 2026',
                        amount: '2 090 DA',
                      ),
                      const _RecentOrder(
                        id: '#PF-0831',
                        date: '10 Juin 2026',
                        amount: '1 350 DA',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SettingsTile(
                  icon: Icons.location_on_outlined,
                  label: 'Mes adresses',
                  subtitle: '2 adresses enregistrees',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.credit_card_rounded,
                  label: 'Paiement',
                  subtitle: 'Paiement a la livraison active',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.notifications_none_rounded,
                  label: 'Notifications',
                  subtitle: _notifications ? 'Activees' : 'Desactivees',
                  trailing: Switch(
                    value: _notifications,
                    activeThumbColor: AppColors.red,
                    onChanged: (value) =>
                        setState(() => _notifications = value),
                  ),
                  onTap: () => setState(() => _notifications = !_notifications),
                ),
                _SettingsTile(
                  icon: Icons.delivery_dining_rounded,
                  label: 'Espace livreur',
                  subtitle: 'Ouvrir la demonstration livreur',
                  onTap: () => widget.onNavigate('driver'),
                ),
                _SettingsTile(
                  icon: Icons.admin_panel_settings_outlined,
                  label: 'Administration',
                  subtitle: 'Ouvrir le tableau de bord admin',
                  onTap: () => widget.onNavigate('admin'),
                ),
                _SettingsTile(
                  icon: Icons.help_outline_rounded,
                  label: 'Aide & Support',
                  subtitle: 'FAQ, appel et support projet',
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _loggingOut ? null : _logout,
                  icon: const Icon(Icons.logout_rounded),
                  label: Text(
                    _loggingOut ? 'Deconnexion...' : 'Se deconnecter',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.red,
                    side: const BorderSide(color: Color(0xFFFFCDD2)),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Mon PF App v2.1.0 - Projet Fin d'Etudes - Yassmine Hajji",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.mutedText, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        active: 'profile',
        cartCount: widget.cartCount,
        onNavigate: widget.onNavigate,
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.mutedText, fontSize: 11),
        ),
      ],
    );
  }
}

class _RecentOrder extends StatelessWidget {
  final String id;
  final String date;
  final String amount;

  const _RecentOrder({
    required this.id,
    required this.date,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.red.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: AppColors.red,
              size: 19,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  id,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  color: AppColors.red,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Text(
                'Livre',
                style: TextStyle(
                  color: AppColors.success,
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

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SurfaceCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.red, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.mutedText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.mutedText,
                ),
          ],
        ),
      ),
    );
  }
}
