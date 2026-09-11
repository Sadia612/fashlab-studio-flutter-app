class CategoryModel {
  final int id;
  final int? parentId;
  final String name;
  final String slug;
  final String description;
  final String image;
  final int productCount;

  CategoryModel({
    required this.id,
    required this.parentId,
    required this.name,
    required this.slug,
    required this.description,
    required this.image,
    required this.productCount,
  });

  factory CategoryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CategoryModel(
      id: int.tryParse(
        json['id']?.toString() ?? '0',
      ) ??
          0,
      parentId: json['parent_id'] == null
          ? null
          : int.tryParse(
        json['parent_id'].toString(),
      ),
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description:
      json['description']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      productCount: int.tryParse(
        json['product_count']?.toString() ?? '0',
      ) ??
          0,
    );
  }
}