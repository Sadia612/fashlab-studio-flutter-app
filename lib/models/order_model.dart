class OrderModel {
  final int id;
  final String orderNumber;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final double total;
  final String formattedTotal;
  final String placedAtHuman;

  final CustomerModel customer;
  final ShippingModel shipping;
  final OrderTotalsModel totals;
  final List<OrderItemModel> items;

  final List<OrderTimelineModel> timeline;
  final List<String> flow;
  final bool canCancel;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.total,
    required this.formattedTotal,
    required this.placedAtHuman,
    required this.customer,
    required this.shipping,
    required this.totals,
    required this.items,
    required this.timeline,
    required this.flow,
    required this.canCancel,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      orderNumber: json['order_number']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      paymentMethod: json['payment_method']?.toString() ?? '',
      total: (json['total'] ?? 0).toDouble(),
      formattedTotal:
      json['formatted_total']?.toString() ?? '',
      placedAtHuman:
      json['placed_at_human']?.toString() ?? '',
      customer: CustomerModel.fromJson(
        json['customer'] ?? {},
      ),
      shipping: ShippingModel.fromJson(
        json['shipping'] ?? {},
      ),
      totals: OrderTotalsModel.fromJson(
        json['totals'] ?? {},
      ),
      items: (json['items'] as List? ?? [])
          .map(
            (item) => OrderItemModel.fromJson(item),
      )
          .toList(),
      timeline: (json['timeline'] as List? ?? [])
          .map(
            (item) => OrderTimelineModel.fromJson(item),
      )
          .toList(),
      flow: (json['flow'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      canCancel: json['can_cancel'] ?? false,
    );
  }
}

class CustomerModel {
  final String name;
  final String email;
  final String phone;

  CustomerModel({
    required this.name,
    required this.email,
    required this.phone,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
    );
  }
}

class ShippingModel {
  final String address;
  final String city;
  final String postalCode;
  final String country;
  final String method;

  ShippingModel({
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.method,
  });

  factory ShippingModel.fromJson(Map<String, dynamic> json) {
    return ShippingModel(
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      postalCode:
      json['postal_code']?.toString() ?? '',
      country:
      json['country']?.toString() ?? '',
      method:
      json['method']?.toString() ?? '',
    );
  }
}

class OrderTotalsModel {
  final double subtotal;
  final double shipping;
  final double discount;
  final double tax;
  final double total;

  OrderTotalsModel({
    required this.subtotal,
    required this.shipping,
    required this.discount,
    required this.tax,
    required this.total,
  });

  factory OrderTotalsModel.fromJson(
      Map<String, dynamic> json) {
    return OrderTotalsModel(
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      shipping: (json['shipping'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }
}

class OrderItemModel {
  final int productId;
  final String name;
  final int quantity;
  final double price;
  final double subtotal;
  final String formattedPrice;
  final String formattedSubtotal;
  final String image;

  OrderItemModel({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.formattedPrice,
    required this.formattedSubtotal,
    required this.image,
  });

  factory OrderItemModel.fromJson(
      Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['product_id'] ?? 0,
      name: json['name']?.toString() ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      formattedPrice:
      json['formatted_price']?.toString() ?? '',
      formattedSubtotal:
      json['formatted_subtotal']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }
}

class OrderTimelineModel {
  final String status;
  final String label;
  final String note;
  final String human;

  OrderTimelineModel({
    required this.status,
    required this.label,
    required this.note,
    required this.human,
  });

  factory OrderTimelineModel.fromJson(
      Map<String, dynamic> json) {
    return OrderTimelineModel(
      status: json['status']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      human: json['human']?.toString() ?? '',
    );
  }
}