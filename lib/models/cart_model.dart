class CartItemModel {
  final String key;
  final int productId;
  final int? variantId;
  final String name;
  final String image;
  final String? variantLabel;
  final int quantity;
  final double unitPrice;
  final double lineTotal;
  final String formattedUnitPrice;
  final String formattedLineTotal;
  final bool available;
  final int maxQuantity;

  CartItemModel({
    required this.key,
    required this.productId,
    required this.variantId,
    required this.name,
    required this.image,
    required this.variantLabel,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.formattedUnitPrice,
    required this.formattedLineTotal,
    required this.available,
    required this.maxQuantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      key: json['key']?.toString() ?? '',
      productId: json['product_id'] ?? 0,
      variantId: json['variant_id'],
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      variantLabel: json['variant_label'],
      quantity: json['quantity'] ?? 1,
      unitPrice: (json['unit_price'] ?? 0).toDouble(),
      lineTotal: (json['line_total'] ?? 0).toDouble(),
      formattedUnitPrice:
      json['formatted_unit_price']?.toString() ?? '',
      formattedLineTotal:
      json['formatted_line_total']?.toString() ?? '',
      available: json['available'] ?? true,
      maxQuantity: json['max_quantity'] ?? 1,
    );
  }
}