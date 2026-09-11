import 'package:get/get.dart';

import '../models/product_model.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';

class HomeController extends GetxController {
  final products = <ProductModel>[].obs;

  final filteredProducts = <ProductModel>[].obs;

  final newArrivals = <ProductModel>[].obs;

  final bestSellers = <ProductModel>[].obs;

  final saleProducts = <ProductModel>[].obs;

  final categories = <CategoryModel>[].obs;

  final isLoading = false.obs;

  final errorMessage = ''.obs;

  final searchQuery = ''.obs;

  final selectedCategories = <String>[].obs;

  final temporaryCategories = <String>[].obs;

  final specialView = ''.obs;

  @override
  void onInit() {
    super.onInit();

    fetchProducts();
    fetchCategories();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final loadedProducts = await ApiService.fetchProducts(
        sort: 'newest',
        page: 1,
        perPage: 120,
      );

      products.assignAll(loadedProducts);

      filteredProducts.assignAll(loadedProducts);

      _buildSections(loadedProducts);
    } catch (e) {
      errorMessage.value = 'Failed to load products: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      final loadedCategories =
      await ApiService.fetchCategories();

      categories.assignAll(loadedCategories);
    } catch (_) {}
  }

  void _buildSections(List<ProductModel> all) {
    newArrivals.assignAll(
      all
          .where((product) => product.isNew)
          .take(10)
          .toList(),
    );

    final sortedBestSellers =
    List<ProductModel>.from(all);

    sortedBestSellers.sort(
          (a, b) => b.rating.compareTo(a.rating),
    );

    bestSellers.assignAll(
      sortedBestSellers.take(10).toList(),
    );

    saleProducts.assignAll(
      all
          .where((product) => product.isSale)
          .take(10)
          .toList(),
    );
  }

  void searchProducts(String query) {
    specialView.value = '';

    searchQuery.value = query;

    _applyFilters();
  }

  void clearSearch() {
    searchQuery.value = '';

    specialView.value = '';

    _applyFilters();
  }

  void startCategoryFilter() {
    temporaryCategories.assignAll(
      selectedCategories,
    );
  }

  void toggleTemporaryCategory(String category) {
    if (category == 'All') {
      temporaryCategories.clear();
      return;
    }

    if (temporaryCategories.contains(category)) {
      temporaryCategories.remove(category);
    } else {
      temporaryCategories.add(category);
    }
  }

  void applyCategoryFilter() {
    selectedCategories.assignAll(
      temporaryCategories,
    );

    specialView.value = '';

    _applyFilters();
  }

  void clearCategoryFilter() {
    temporaryCategories.clear();

    selectedCategories.clear();

    specialView.value = '';

    _applyFilters();
  }

  void selectCategory(String category) {
    specialView.value = '';

    if (category == 'All') {
      selectedCategories.clear();
    } else {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    }

    _applyFilters();
  }

  void _applyFilters() {
    List<ProductModel> result =
    List<ProductModel>.from(products);

    if (selectedCategories.isNotEmpty) {
      result = result.where((product) {
        final productCategories = product.category
            .toLowerCase()
            .replaceAll('-', ' ')
            .split(',')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .toList();

        return selectedCategories.any((selectedCategory) {
          final selected = selectedCategory
              .toLowerCase()
              .replaceAll('-', ' ')
              .trim();

          // Direct category match
          if (productCategories.contains(selected)) {
            return true;
          }

          // 2 Piece / Two Piece
          if (selected == 'two piece') {
            return productCategories.contains('two piece') ||
                productCategories.contains('2 piece');
          }

          // 3 Piece / Three Piece
          if (selected == 'three piece') {
            return productCategories.contains('three piece') ||
                productCategories.contains('3 piece');
          }

          return false;
        });
      }).toList();
    }

    final query =
    searchQuery.value.trim().toLowerCase();

    if (query.isNotEmpty) {
      result = result.where((product) {
        final nameMatch =
        product.name.toLowerCase().contains(query);

        final categoryMatch =
        product.category.toLowerCase().contains(query);

        final fabricMatch =
        product.fabric.toLowerCase().contains(query);

        final colorMatch = product.colors.any(
              (color) =>
              color.toLowerCase().contains(query),
        );

        return nameMatch ||
            categoryMatch ||
            fabricMatch ||
            colorMatch;
      }).toList();
    }

    filteredProducts.assignAll(result);
  }
  void showNewArrivals() {
    specialView.value = 'new_arrivals';

    searchQuery.value = '';

    selectedCategories.clear();

    temporaryCategories.clear();

    filteredProducts.assignAll(
      newArrivals,
    );
  }

  void showBestSellers() {
    specialView.value = 'best_sellers';

    searchQuery.value = '';

    selectedCategories.clear();

    temporaryCategories.clear();

    filteredProducts.assignAll(
      products,
    );
  }

  void showSaleProducts() {
    specialView.value = 'sale';

    searchQuery.value = '';

    selectedCategories.clear();

    temporaryCategories.clear();

    filteredProducts.assignAll(
      products,
    );
  }

  void showAllProducts() {
    specialView.value = '';

    searchQuery.value = '';

    selectedCategories.clear();

    temporaryCategories.clear();

    filteredProducts.assignAll(
      products,
    );
  }

  List<ProductModel> get displayedProducts {
    return filteredProducts;
  }

  bool get hasActiveFilters {
    return selectedCategories.isNotEmpty ||
        searchQuery.value.trim().isNotEmpty;
  }

  String get selectedCategoryText {
    if (selectedCategories.isEmpty) {
      return 'All';
    }

    return selectedCategories.join(', ');
  }

  bool get isNewArrivalsView {
    return specialView.value == 'new_arrivals';
  }

  bool get isBestSellersView {
    return specialView.value == 'best_sellers';
  }

  bool get isSaleView {
    return specialView.value == 'sale';
  }
}