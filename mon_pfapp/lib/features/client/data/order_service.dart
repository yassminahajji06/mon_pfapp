import 'package:mon_pfapp/core/constants.dart';
import 'package:mon_pfapp/data/api_client.dart';
import 'package:mon_pfapp/data/demo_data.dart';
import 'package:mon_pfapp/domain/models/cart_item.dart';
import 'package:mon_pfapp/domain/models/order_model.dart';

class OrderService {
  static Future<List<OrderModel>> fetchOrders() async {
    if (AppConstants.demoMode) return DemoData.recentOrders;

    try {
      final data = await ApiClient.get('/orders', authenticated: true);
      final orders = data['orders'];

      if (orders is! List) return [];

      return orders
          .whereType<Map<String, dynamic>>()
          .map(OrderModel.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<List<OrderModel>> fetchDriverOrders() async {
    if (AppConstants.demoMode) return DemoData.recentOrders;

    try {
      final data = await ApiClient.get('/driver/orders', authenticated: true);
      final orders = data['orders'];

      if (orders is! List) return [];

      return orders
          .whereType<Map<String, dynamic>>()
          .map(OrderModel.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> fetchStats() async {
    if (AppConstants.demoMode) {
      return {
        'ordersCount': 47,
        'inProgressCount': 8,
        'deliveredCount': 39,
        'revenue': 402000,
        'menuItemsCount': DemoData.menuItems.length,
        'clientsCount': 134,
      };
    }

    try {
      final data = await ApiClient.get('/admin/stats', authenticated: true);
      final stats = data['stats'];
      return stats is Map<String, dynamic> ? stats : {};
    } catch (_) {
      return {};
    }
  }

  static Future<OrderModel> createOrder({
    required List<CartItem> items,
    required String address,
  }) async {
    if (AppConstants.demoMode) {
      await Future<void>.delayed(const Duration(milliseconds: 450));
      return OrderModel(
        id: '#PF-DEMO',
        client: 'Yassmine H.',
        address: address,
        status: 'Preparation',
        statusKey: 'preparation',
        time: 'Maintenant',
        amount: items.fold(250, (sum, item) => sum + item.total),
        itemsCount: items.length,
      );
    }

    final data = await ApiClient.post(
      '/orders',
      authenticated: true,
      body: {
        'address': address,
        'payment_method': 'cash',
        'items': items
            .map(
              (item) => {
                'menu_item_id': item.item.id,
                'quantity': item.quantity,
              },
            )
            .toList(),
      },
    );

    final order = data['order'];
    if (order is Map<String, dynamic>) return OrderModel.fromJson(order);

    throw const ApiException('Commande creee mais reponse invalide.');
  }

  static Future<void> acceptForDelivery(OrderModel order) async {
    if (AppConstants.demoMode || order.databaseId == null) return;

    await ApiClient.patch(
      '/driver/orders/${order.databaseId}/accept',
      authenticated: true,
    );
  }
}
