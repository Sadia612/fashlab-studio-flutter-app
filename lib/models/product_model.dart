class ProductModel {
  final int id;
  final String name;
  final String slug;
  final String image;

  final double price;
  final double salePrice;
  final double finalPrice;

  final bool onSale;
  final int discountPercent;

  final bool inStock;
  final int stockQuantity;
  final String stockStatus;

  final double rating;
  final int ratingCount;
  final bool featured;

  final String category;
  final List<String> colors;
  final String fabric;

  final String? description;
  final List<String> sizes;
  final List<String> images;

  final List<ProductBadge> badges;

  ProductModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.price,
    required this.salePrice,
    required this.finalPrice,
    required this.onSale,
    required this.discountPercent,
    required this.inStock,
    required this.stockQuantity,
    required this.stockStatus,
    required this.rating,
    required this.ratingCount,
    required this.featured,
    required this.category,
    required this.colors,
    required this.fabric,
    required this.description,
    required this.sizes,
    required this.images,
    required this.badges,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawImages = json['images'];

    final List<String> parsedImages = rawImages is List
        ? rawImages.map((e) => e.toString()).toList()
        : [];

    final String primaryImage =
        json['image']?.toString() ??
            (parsedImages.isNotEmpty ? parsedImages.first : '');

    return ProductModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,

      name: json['name']?.toString() ?? '',

      slug: json['slug']?.toString() ?? '',

      image: primaryImage,

      price: double.tryParse(
        json['price']?.toString() ?? '0',
      ) ??
          0,

      salePrice: double.tryParse(
        json['sale_price']?.toString() ?? '0',
      ) ??
          0,

      finalPrice: double.tryParse(
        json['final_price']?.toString() ?? '0',
      ) ??
          0,

      onSale: json['on_sale'] == true,

      discountPercent: int.tryParse(
        json['discount_percent']?.toString() ?? '0',
      ) ??
          0,

      inStock: json['in_stock'] == true,

      stockQuantity: int.tryParse(
        json['stock_quantity']?.toString() ?? '0',
      ) ??
          0,

      stockStatus:
      json['stock_status']?.toString() ?? '',

      rating: double.tryParse(
        json['rating']?.toString() ?? '0',
      ) ??
          0,

      ratingCount: int.tryParse(
        json['rating_count']?.toString() ?? '0',
      ) ??
          0,

      featured: json['featured'] == true,

      category:
      json['category']?.toString() ?? '',

      colors: json['colors'] is List
          ? (json['colors'] as List)
          .map((e) => e.toString())
          .toList()
          : json['colors'] != null
          ? [json['colors'].toString()]
          : [],

      fabric:
      json['fabric']?.toString() ?? '',

      description:
      json['short_description']?.toString() ??
          json['description']?.toString(),

      sizes: json['sizes'] is List
          ? (json['sizes'] as List)
          .map((e) => e.toString())
          .toList()
          : [],

      images: parsedImages,

      badges: (json['badges'] as List? ?? [])
          .map(
            (badge) => ProductBadge.fromJson(
          Map<String, dynamic>.from(badge),
        ),
      )
          .toList(),
    );
  }

  bool get isNew {
    return badges.any(
          (badge) =>
      badge.type.toLowerCase() == 'new',
    );
  }

  bool get isSale {
    return badges.any(
          (badge) =>
      badge.type.toLowerCase() == 'sale',
    ) ||
        onSale;
  }

  bool get isOutOfStock {
    return !inStock || stockQuantity <= 0;
  }

  bool get isBestSeller {
    return featured || rating >= 4.0;
  }
}

class ProductBadge {
  final String label;
  final String type;

  ProductBadge({
    required this.label,
    required this.type,
  });

  factory ProductBadge.fromJson(
      Map<String, dynamic> json,
      ) {
    return ProductBadge(
      label: json['label']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
    );
  }
}