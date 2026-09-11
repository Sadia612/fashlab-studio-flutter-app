import 'package:get/get.dart';

import '../models/product_model.dart';
import '../services/api_service.dart';

class ShopController extends GetxController {
  final products = <ProductModel>[].obs;

  final isLoading = false.obs;

  final errorMessage = ''.obs;

  final selectedTitle = 'All Products'.obs;

  @override
  void onInit() {
    super.onInit();

    loadAllProducts();
  }

  Future<void> loadAllProducts() async {
    await _loadProducts(
      title: 'All Products',
    );
  }

  Future<void> loadFabric(
      String title, {
        String? category,
        String? query,
      }) async {
    await _loadProducts(
      title: title,
      category: category,
      query: query,
    );
  }

  Future<void> loadPrice(
      String title,
      String price,
      ) async {
    await _loadProducts(
      title: title,
      price: price,
    );
  }

  Future<void> loadFeatured(
      String title, {
        String? sort,
        bool sale = false,
        bool featured = false,
      }) async {
    await _loadProducts(
      title: title,
      sort: sort,
      sale: sale,
      featured: featured,
    );
  }

  Future<void> _loadProducts({
    required String title,
    String? query,
    String? category,
    String? price,
    String? sort,
    bool sale = false,
    bool featured = false,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      selectedTitle.value = title;

      final result =
      await ApiService.fetchShopProducts(
        query: query,
        category: category,
        price: price,
        sort: sort,
        sale: sale,
        featured: featured,
      );

      products.assignAll(result);
    } catch (e) {
      products.clear();

      errorMessage.value =
      'Failed to load products: $e';
    } finally {
      isLoading.value = false;
    }
  }
}