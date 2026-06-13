import 'package:mon_pfapp/domain/models/menu_item.dart';

class CartItem {
  final MenuItem item;
  final int quantity;

  const CartItem({required this.item, required this.quantity});

  int get total => item.price * quantity;

  CartItem copyWith({MenuItem? item, int? quantity}) {
    return CartItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
    );
  }
}
