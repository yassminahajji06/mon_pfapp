class OrderModel {
  final String id;
  final int? databaseId;
  final String client;
  final String address;
  final String status;
  final String statusKey;
  final String time;
  final int amount;
  final int itemsCount;

  const OrderModel({
    required this.id,
    this.databaseId,
    required this.client,
    required this.address,
    required this.status,
    this.statusKey = '',
    required this.time,
    required this.amount,
    this.itemsCount = 0,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final items = json['items'];

    return OrderModel(
      id: json['id']?.toString() ?? '',
      databaseId: json['databaseId'] is int ? json['databaseId'] as int : null,
      client: json['client']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      statusKey: json['statusKey']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      amount: _intFromJson(json['amount']),
      itemsCount: items is List
          ? items.length
          : _intFromJson(json['itemsCount']),
    );
  }

  static int _intFromJson(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.round();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
