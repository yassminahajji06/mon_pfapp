import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mon_pfapp/domain/models/order_model.dart';
import 'package:mon_pfapp/shared/widgets/app_ui.dart';

class TrackingScreen extends StatefulWidget {
  final ValueChanged<String> onNavigate;
  final OrderModel? order;

  const TrackingScreen({super.key, required this.onNavigate, this.order});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  double _progress = 0.64;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 700), (_) {
      if (!mounted) return;
      setState(
        () => _progress = (_progress + 0.01).clamp(0.64, 0.92).toDouble(),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final orderId = order?.id ?? '#PF-2024-0847';
    final estimated = order?.status.toLowerCase() == 'livre'
        ? '0 min'
        : '18 min';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          RedHeader(
            title: 'Suivi de livraison',
            subtitle: 'Commande $orderId',
            leading: IconButton.filled(
              onPressed: () => widget.onNavigate('orders'),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.18),
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.arrow_back_rounded),
              tooltip: 'Retour',
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              children: [
                const _MapPreview(),
                const SizedBox(height: 14),
                SurfaceCard(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Temps estime',
                              style: TextStyle(
                                color: AppColors.mutedText,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              estimated,
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              order?.status ?? 'Arrivee vers 15:10',
                              style: const TextStyle(
                                color: AppColors.mutedText,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          color: AppColors.red.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.schedule_rounded,
                          color: AppColors.red,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Progression',
                              style: TextStyle(
                                color: AppColors.text,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Text(
                            '${(_progress * 100).round()}%',
                            style: const TextStyle(
                              color: AppColors.red,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        minHeight: 8,
                        value: _progress,
                        backgroundColor: const Color(0xFFEFEFEF),
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Etapes de la commande',
                        style: TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _TrackingStep(
                        icon: Icons.check_circle_rounded,
                        label: 'Commande confirmee',
                        time: '14:32',
                        done: true,
                      ),
                      _TrackingStep(
                        icon: Icons.restaurant_rounded,
                        label: 'En preparation',
                        time: '14:35',
                        done: true,
                      ),
                      _TrackingStep(
                        icon: Icons.delivery_dining_rounded,
                        label: 'Livreur en route',
                        time: '14:52',
                        done: true,
                        active: true,
                      ),
                      const _TrackingStep(
                        icon: Icons.home_rounded,
                        label: 'Livraison effectuee',
                        time: '~15:10',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SurfaceCard(
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFEBEE),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'KB',
                            style: TextStyle(
                              color: AppColors.red,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Karim B.',
                              style: TextStyle(
                                color: AppColors.text,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Livreur - Yamaha NMAX',
                              style: TextStyle(
                                color: AppColors.mutedText,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '4.9 - Alger Centre',
                              style: TextStyle(
                                color: AppColors.warning,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: () {},
                        icon: const Icon(Icons.phone_rounded),
                        tooltip: 'Appeler',
                      ),
                      IconButton.filledTonal(
                        onPressed: () {},
                        icon: const Icon(Icons.message_rounded),
                        tooltip: 'Message',
                      ),
                    ],
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

class _MapPreview extends StatelessWidget {
  const _MapPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFE8ECEF), Color(0xFFF8F8F8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _RoutePainter())),
          const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.map_outlined, color: AppColors.mutedText, size: 42),
                SizedBox(height: 6),
                Text(
                  'Carte de livraison simulee',
                  style: TextStyle(
                    color: AppColors.mutedText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Livreur a environ 1.2 km',
                  style: TextStyle(color: AppColors.mutedText, fontSize: 12),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 28,
            bottom: 28,
            child: Icon(Icons.storefront_rounded, color: AppColors.success),
          ),
          const Positioned(
            right: 38,
            top: 34,
            child: Icon(
              Icons.delivery_dining_rounded,
              color: AppColors.red,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.red.withValues(alpha: 0.45)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(42, size.height - 42)
      ..lineTo(size.width * 0.35, size.height * 0.62)
      ..lineTo(size.width * 0.58, size.height * 0.68)
      ..lineTo(size.width - 52, 52);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TrackingStep extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;
  final bool done;
  final bool active;

  const _TrackingStep({
    required this.icon,
    required this.label,
    required this.time,
    this.done = false,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = done ? AppColors.red : AppColors.mutedText;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: done ? AppColors.red : const Color(0xFFF0F0F0),
              shape: BoxShape.circle,
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: AppColors.red.withValues(alpha: 0.22),
                        blurRadius: 0,
                        spreadRadius: 6,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              color: done ? Colors.white : AppColors.mutedText,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: color, fontWeight: FontWeight.w900),
                ),
                if (active)
                  const Text(
                    'En cours',
                    style: TextStyle(
                      color: AppColors.red,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(color: AppColors.mutedText, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
