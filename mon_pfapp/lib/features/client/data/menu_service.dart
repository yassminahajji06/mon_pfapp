import 'package:mon_pfapp/core/constants.dart';
import 'package:mon_pfapp/data/api_client.dart';
import 'package:mon_pfapp/data/demo_data.dart';
import 'package:mon_pfapp/domain/models/menu_item.dart';

class MenuCatalog {
  final List<MenuCategory> categories;
  final List<MenuItem> items;

  const MenuCatalog({required this.categories, required this.items});

  factory MenuCatalog.demo() {
    return const MenuCatalog(
      categories: DemoData.categories,
      items: DemoData.menuItems,
    );
  }
}

class MenuService {
  static Future<MenuCatalog> fetchCatalog() async {
    if (AppConstants.demoMode) return MenuCatalog.demo();

    try {
      final data = await ApiClient.get('/menu');
      final categories = data['categories'];
      final items = data['items'];

      return MenuCatalog(
        categories: categories is List
            ? categories
                  .whereType<Map<String, dynamic>>()
                  .map(MenuCategory.fromJson)
                  .toList()
            : DemoData.categories,
        items: items is List
            ? items
                  .whereType<Map<String, dynamic>>()
                  .map(MenuItem.fromJson)
                  .toList()
            : DemoData.menuItems,
      );
    } catch (_) {
      return MenuCatalog.demo();
    }
  }
}
