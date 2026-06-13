class OrderModel {
  final String id;
  final String client;
  final String address;
  final String status;
  final String time;
  final int amount;

  const OrderModel({
    required this.id,
    required this.client,
    required this.address,
    required this.status,
    required this.time,
    required this.amount,
  });
}
