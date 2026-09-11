import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_theme.dart';
import '../../controllers/home_controller.dart';
import '../../models/product_model.dart';
import '../../services/api_service.dart';
import '../../views/shop/shop_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  final newsletterEmail = ''.obs;
  final isNewsletterLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.cream,
      drawer: _buildDrawer(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: AppTheme.primary,
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                controller.errorMessage.value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 13,
                ),
              ),
            ),
          );
        }

        final bool isSearching =
            controller.searchQuery.value
                .trim()
                .isNotEmpty ||
                controller.hasActiveFilters;

        final List<ProductModel> searchResults =
            controller.displayedProducts;

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildTopBar(),
              ),
              SliverToBoxAdapter(
                child: _buildHeader(context),
              ),
              SliverToBoxAdapter(
                child: _buildSearchBar(),
              ),

              if (isSearching) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SEARCH RESULTS (${searchResults.length})',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: AppTheme.primary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (controller.selectedCategories.isNotEmpty) {
                              controller.clearCategoryFilter();
                            } else {
                              controller.clearSearch();
                            }
                          },
                          child: Text(
                            controller.selectedCategories.isNotEmpty
                                ? 'Clear Filter'
                                : 'Clear Search',
                            style: TextStyle(
                              color: AppTheme.gold,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (searchResults.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 60,
                      ),
                      child: Center(
                        child: Text(
                          'No products match your search query.',
                          style: TextStyle(
                            color: AppTheme.textLight,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                    ),
                    sliver: SliverGrid(
                      delegate:
                      SliverChildBuilderDelegate(
                            (context, index) {
                          return _productGridCard(
                            searchResults[index],
                          );
                        },
                        childCount: searchResults.length,
                      ),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.58,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                      ),
                    ),
                  ),
              ] else
                ...[
                  SliverToBoxAdapter(
                    child: _buildHeroBanner(),
                  ),
                  SliverToBoxAdapter(
                    child: _buildSectionTitle(
                      'Shop By Category',
                      'Explore our collections',
                      onViewAll: _showFilterSheet,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _buildCategories(),
                  ),
                  SliverToBoxAdapter(
                    child: _buildSectionTitle(
                      'New Arrivals',
                      'Discover the latest styles',
                      onViewAll: _showNewArrivals,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _buildProductHorizontalList(
                      controller.newArrivals,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _buildEditorialSection(),
                  ),
                  SliverToBoxAdapter(
                    child: _buildSectionTitle(
                      'Best Sellers',
                      'Loved by our customers',
                      onViewAll: _showBestSellers,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _buildProductHorizontalList(
                      controller.bestSellers,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _buildWhyUs(),
                  ),
                  SliverToBoxAdapter(
                    child: _buildSectionTitle(
                      'On Sale',
                      'Elegant styles at special prices',
                      onViewAll: _showSaleProducts,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _buildSaleProducts(),
                  ),
                  SliverToBoxAdapter(
                    child: _buildNewsletter(),
                  ),
                  SliverToBoxAdapter(
                    child: _buildServiceStrip(),
                  ),
                ],
              const SliverToBoxAdapter(
                child: SizedBox(height: 30),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // ------------------------------------------------------------
  // TOP BAR
  // ------------------------------------------------------------

  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 9,
      ),
      color: AppTheme.primaryDark,
      child: const Text(
        'Free delivery on orders above Rs. 8,000',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppTheme.goldTint,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        16,
        18,
        10,
      ),
      child: Row(
        children: [
          Builder(
            builder: (context) {
              return _iconButton(
                Icons.menu_rounded,
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 38,
              child: Image.asset(
                'assets/images/logo-wordmark.png',
                fit: BoxFit.contain,
                errorBuilder: (context,
                    error,
                    stackTrace,) {
                  return const Center(
                    child: Text(
                      'FASHLAB STUDIO',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          _iconButton(
            Icons.favorite_border_rounded,
            onTap: () {
              Get.toNamed(AppRoutes.wishlist);
            },
          ),
          const SizedBox(width: 8),
          _iconButton(
            Icons.shopping_bag_outlined,
            onTap: () {
              Get.toNamed(AppRoutes.cart);
            },
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // DRAWER
  // ------------------------------------------------------------

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppTheme.cream,
      child: SafeArea(
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                26,
                30,
                26,
                26,
              ),
              child: Image.asset(
                'assets/images/logo-wordmark.png',
                height: 42,
                fit: BoxFit.contain,
                errorBuilder: (context,
                    error,
                    stackTrace,) {
                  return const Text(
                    'FASHLAB STUDIO',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  );
                },
              ),
            ),
            const Divider(
              height: 1,
              thickness: 0.8,
              color: AppTheme.border,
            ),
            const SizedBox(height: 18),
            _drawerItem(
              icon: Icons.receipt_long_outlined,
              title: 'MY ORDERS',
              onTap: () {
                Get.back();
                Get.toNamed(
                  AppRoutes.orderHistory,
                );
              },
            ),
            _drawerItem(
              icon: Icons.local_shipping_outlined,
              title: 'TRACK ORDER',
              onTap: () {
                Get.back();
                Get.toNamed(
                  AppRoutes.trackOrder,
                );
              },
            ),
            const Spacer(),
            const Divider(
              height: 1,
              thickness: 0.8,
              color: AppTheme.border,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(
                26,
                18,
                26,
                24,
              ),
              child: Text(
                'FASHLAB STUDIO',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 9,
                  letterSpacing: 1.8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.border,
            width: 0.8,
          ),
        ),
        child: Icon(
          icon,
          size: 21,
          color: AppTheme.ink,
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 26,
          vertical: 17,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 21,
              color: AppTheme.primary,
            ),
            const SizedBox(width: 17),
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.ink,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SEARCH BAR
  // ------------------------------------------------------------

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        6,
        18,
        18,
      ),
      child: TextField(
        onChanged: (val) {
          controller.searchProducts(val);
        },
        textInputAction:
        TextInputAction.search,
        style: const TextStyle(
          color: AppTheme.ink,
          fontSize: 13,
        ),
        decoration: InputDecoration(
          hintText:
          'Search products, fabrics or styles',
          hintStyle: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 11,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 21,
            color: AppTheme.gold,
          ),
          suffixIcon: Obx(() {
            if (controller
                .searchQuery.value
                .isNotEmpty) {
              return IconButton(
                onPressed: () {
                  controller.clearSearch();
                },
                icon: const Icon(
                  Icons.close_rounded,
                  size: 19,
                  color: AppTheme.ink,
                ),
              );
            }

            return IconButton(
              onPressed: _showFilterSheet,
              icon: const Icon(
                Icons.tune_rounded,
                size: 19,
                color: AppTheme.primary,
              ),
            );
          }),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(4),
            borderSide: const BorderSide(
              color: AppTheme.border,
              width: 0.8,
            ),
          ),
          enabledBorder:
          OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(4),
            borderSide: const BorderSide(
              color: AppTheme.border,
              width: 0.8,
            ),
          ),
          focusedBorder:
          OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(4),
            borderSide: const BorderSide(
              color: AppTheme.gold,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // FILTER SHEET
  // ------------------------------------------------------------

  void _showFilterSheet() {
    controller.startCategoryFilter();

    Get.bottomSheet(
      Obx(() {
        final categories =
            controller.categories;

        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.cream,
            borderRadius:
            BorderRadius.vertical(
              top: Radius.circular(18),
            ),
          ),
          padding:
          const EdgeInsets.fromLTRB(
            22,
            12,
            22,
            28,
          ),
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration:
                  BoxDecoration(
                    color:
                    AppTheme.borderStrong,
                    borderRadius:
                    BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'FILTER BY CATEGORY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                  FontWeight.w700,
                  letterSpacing: 1.3,
                  color:
                  AppTheme.primary,
                ),
              ),
              const SizedBox(height: 18),

              if (categories.isEmpty)
                const Center(
                  child: Padding(
                    padding:
                    EdgeInsets.all(20),
                    child: Text(
                      'Loading categories...',
                      style: TextStyle(
                        color:
                        AppTheme.textLight,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildFilterCategoryChip(
                      'All',
                      controller
                          .temporaryCategories
                          .isEmpty,
                          () {
                        controller
                            .temporaryCategories
                            .clear();
                      },
                    ),
                    ...categories.map(
                          (category) {
                        final selected =
                        controller
                            .temporaryCategories
                            .contains(
                          category.name,
                        );

                        return _buildFilterCategoryChip(
                          category.name,
                          selected,
                              () {
                            controller
                                .toggleTemporaryCategory(
                              category.name,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        controller
                            .clearCategoryFilter();
                        Get.back();
                      },
                      style: OutlinedButton
                          .styleFrom(
                        foregroundColor:
                        AppTheme.primary,
                        side:
                        const BorderSide(
                          color:
                          AppTheme.primary,
                        ),
                        shape:
                        const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.zero,
                        ),
                      ),
                      child: const Text(
                        'CLEAR',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight:
                          FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller
                            .applyCategoryFilter();
                        Get.back();
                      },
                      style: ElevatedButton
                          .styleFrom(
                        backgroundColor:
                        AppTheme.primary,
                        foregroundColor:
                        Colors.white,
                        elevation: 0,
                        shape:
                        const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.zero,
                        ),
                      ),
                      child: const Text(
                        'APPLY',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight:
                          FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
      isScrollControlled: true,
    );
  }

  Widget _buildFilterCategoryChip(String category,
      bool selected,
      VoidCallback onTap,) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primary
              : Colors.white,
          border: Border.all(
            color: selected
                ? AppTheme.primary
                : AppTheme.border,
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: selected
                ? Colors.white
                : AppTheme.text,
            fontSize: 10,
            fontWeight:
            FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // HERO BANNER
  // ------------------------------------------------------------

  Widget _buildHeroBanner() {
    return Container(
      height: 310,
      margin:
      const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(4),
        color: AppTheme.creamDark,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: 20,
            bottom: 0,
            child: Icon(
              Icons.checkroom_outlined,
              size: 230,
              color: AppTheme.goldLight
                  .withValues(alpha: 0.35),
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.fromLTRB(
              25,
              38,
              25,
              28,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'NEW SEASON',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight:
                    FontWeight.w600,
                    letterSpacing: 2.2,
                    color: AppTheme.gold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'The\nSignature Edit',
                  style: TextStyle(
                    fontSize: 34,
                    height: 1.05,
                    fontWeight:
                    FontWeight.w300,
                    color:
                    AppTheme.primaryDark,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Timeless silhouettes.\nContemporary elegance.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color:
                    AppTheme.textLight,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    _heroButton(
                      'SHOP NEW ARRIVALS',
                      filled: true,
                      onTap:
                      _showNewArrivals,
                    ),
                    const SizedBox(width: 10),
                    _heroButton(
                      'EXPLORE',
                      filled: false,
                      onTap:
                      _showFilterSheet,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNewArrivals() {
    if (controller.newArrivals.isEmpty) {
      Get.snackbar(
        'New Arrivals',
        'No new arrivals are available right now.',
        snackPosition:
        SnackPosition.BOTTOM,
        duration:
        const Duration(seconds: 2),
      );
      return;
    }

    controller.filteredProducts
        .assignAll(
      controller.newArrivals,
    );

    controller.searchQuery.value =
    'new arrivals';
  }

  Widget _heroButton(String title, {
    required bool filled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: filled
              ? AppTheme.primary
              : Colors.transparent,
          border: Border.all(
            color: AppTheme.primary,
            width: 0.8,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: filled
                ? Colors.white
                : AppTheme.primary,
            fontSize: 9,
            fontWeight:
            FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  void _showBestSellers() {
    if (controller.bestSellers.isEmpty) {
      Get.snackbar(
        'Best Sellers',
        'No best sellers are available right now.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    controller.filteredProducts.assignAll(
      controller.bestSellers,
    );

    controller.searchQuery.value = 'best sellers';
  }


  void _showSaleProducts() {
    if (controller.saleProducts.isEmpty) {
      Get.snackbar(
        'On Sale',
        'No sale products are available right now.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    controller.filteredProducts.assignAll(
      controller.saleProducts,
    );

    controller.searchQuery.value = 'on sale';
  }

  // ------------------------------------------------------------
  // SECTION TITLE
  // ------------------------------------------------------------

  Widget _buildSectionTitle(String title,
      String subtitle, {
        required VoidCallback onViewAll,
      }) {
    return Padding(
      padding:
      const EdgeInsets.fromLTRB(
        18,
        34,
        18,
        16,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    AppTheme.primaryDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style:
                  const TextStyle(
                    fontSize: 11,
                    color:
                    AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onViewAll,
            child: const Padding(
              padding:
              EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 2,
              ),
              child: Text(
                'VIEW ALL',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight:
                  FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppTheme.gold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // DYNAMIC CATEGORIES
  // ------------------------------------------------------------

  Widget _buildCategories() {
    return SizedBox(
      height: 92,
      child: Obx(() {
        if (controller.categories.isEmpty) {
          return const Center(
            child: Text(
              'Loading categories...',
              style: TextStyle(
                color:
                AppTheme.textLight,
                fontSize: 12,
              ),
            ),
          );
        }

        return ListView.builder(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          scrollDirection:
          Axis.horizontal,
          itemCount:
          controller.categories.length,
          itemBuilder:
              (context, index) {
            final category =
            controller.categories[
            index];

            return Obx(() {
              final isSelected =
              controller
                  .selectedCategories
                  .contains(
                category.name,
              );

              return GestureDetector(
                onTap: () {
                  controller
                      .selectCategory(
                    category.name,
                  );
                },
                child: Container(
                  width: 92,
                  margin:
                  const EdgeInsets.only(
                    right: 12,
                  ),
                  decoration:
                  BoxDecoration(
                    color: isSelected
                        ? AppTheme.primary
                        : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.border,
                      width: 0.8,
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      4,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                    children: [
                      Icon(
                        _categoryIcon(
                          category.slug,
                        ),
                        size: 25,
                        color: isSelected
                            ? AppTheme
                            .goldLight
                            : AppTheme.gold,
                      ),
                      const SizedBox(
                        height: 9,
                      ),
                      Padding(
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 5,
                        ),
                        child: Text(
                          category.name,
                          textAlign:
                          TextAlign.center,
                          maxLines: 2,
                          overflow:
                          TextOverflow
                              .ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight:
                            FontWeight
                                .w500,
                            color: isSelected
                                ? Colors.white
                                : AppTheme
                                .text,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          },
        );
      }),
    );
  }

  IconData _categoryIcon(String slug,) {
    switch (slug.toLowerCase()) {
      case 'stitched':
      case 'pret-wear':
      case 'eastern-wear':
      case 'western-wear':
        return Icons.checkroom_outlined;

      case 'unstitched':
        return Icons.layers_outlined;

      case 'new-arrivals':
        return Icons.auto_awesome_outlined;

      case 'best-sellers':
        return Icons.star_border_rounded;

      case 'sale':
        return Icons.local_offer_outlined;

      case 'formal-wear':
        return Icons.workspace_premium_outlined;

      case 'casual-wear':
        return Icons.weekend_outlined;

      case 'luxury-collection':
        return Icons.diamond_outlined;

      case 'eid-collection':
      case 'festive-collection':
        return Icons.celebration_outlined;

      case 'lawn-collection':
      case 'cotton-collection':
      case 'linen-collection':
        return Icons.eco_outlined;

      case 'embroidered':
        return Icons.brush_outlined;

      case 'printed':
        return Icons.pattern_outlined;

      case 'two-piece':
      case 'three-piece':
        return Icons.style_outlined;

      default:
        return Icons.grid_view_outlined;
    }
  }

  // ------------------------------------------------------------
  // HORIZONTAL PRODUCTS LIST
  // ------------------------------------------------------------

  Widget _buildProductHorizontalList(List<ProductModel> products,) {
    if (products.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(
          child: Text(
            'No products available in this section',
            style: TextStyle(
              color: AppTheme.textLight,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 390,
      child: ListView.builder(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 18,
        ),
        scrollDirection:
        Axis.horizontal,
        itemCount: products.length,
        itemBuilder:
            (context, index) {
          return _productCard(
            products[index],
          );
        },
      ),
    );
  }

  Widget _productCard(ProductModel product,) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.product,
          arguments: product,
        );
      },
      child: Container(
        width: 205,
        margin:
        const EdgeInsets.only(
          right: 14,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 245,
                  width: 205,
                  decoration:
                  BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color:
                      AppTheme.border,
                      width: 0.8,
                    ),
                  ),
                  clipBehavior:
                  Clip.antiAlias,
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context,
                        error,
                        stackTrace,) {
                      return const Center(
                        child: Icon(
                          Icons
                              .image_not_supported_outlined,
                          size: 30,
                          color:
                          AppTheme
                              .textMuted,
                        ),
                      );
                    },
                    loadingBuilder: (context,
                        child,
                        loadingProgress,) {
                      if (loadingProgress ==
                          null) {
                        return child;
                      }

                      return const Center(
                        child: SizedBox(
                          height: 22,
                          width: 22,
                          child:
                          CircularProgressIndicator(
                            strokeWidth:
                            1.5,
                            color:
                            AppTheme
                                .gold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (product.isSale)
                  Positioned(
                    top: 10,
                    left: 10,
                    child:
                    _productBadge(
                      'SALE',
                      black: true,
                    ),
                  )
                else
                  if (product.isNew)
                    Positioned(
                      top: 10,
                      left: 10,
                      child:
                      _productBadge(
                        'NEW',
                        black: false,
                      ),
                    ),
                if (product.isOutOfStock)
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child:
                    _productBadge(
                      'OUT OF STOCK',
                      black: false,
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.white
                        .withValues(
                      alpha: 0.9,
                    ),
                    shape:
                    const CircleBorder(),
                    child: InkWell(
                      customBorder:
                      const CircleBorder(),
                      onTap: () {
                        Get.toNamed(
                          AppRoutes
                              .wishlist,
                        );
                      },
                      child:
                      const SizedBox(
                        height: 36,
                        width: 36,
                        child: Icon(
                          Icons
                              .favorite_border_rounded,
                          size: 18,
                          color:
                          AppTheme
                              .primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11),
            Text(
              product.category.isNotEmpty
                  ? product.category
                  : 'FASHLAB STUDIO',
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 9,
                fontWeight:
                FontWeight.w500,
                color: AppTheme.gold,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              product.name,
              maxLines: 2,
              overflow:
              TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight:
                FontWeight.w500,
                color: AppTheme.ink,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [
                Text(
                  'Rs. ${product.finalPrice.toStringAsFixed(0)}',
                  style:
                  const TextStyle(
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w700,
                    color:
                    AppTheme.primaryDark,
                  ),
                ),
                if (product.isSale) ...[
                  const SizedBox(width: 7),
                  Text(
                    'Rs. ${product.price.toStringAsFixed(0)}',
                    style:
                    const TextStyle(
                      fontSize: 10,
                      color:
                      AppTheme.textMuted,
                      decoration:
                      TextDecoration
                          .lineThrough,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 9),
            SizedBox(
              width: double.infinity,
              height: 34,
              child: OutlinedButton(
                onPressed:
                product.isOutOfStock
                    ? null
                    : () {
                  Get.toNamed(
                    AppRoutes
                        .product,
                    arguments:
                    product,
                  );
                },
                style: OutlinedButton
                    .styleFrom(
                  foregroundColor:
                  AppTheme.primary,
                  disabledForegroundColor:
                  AppTheme.textMuted,
                  side: BorderSide(
                    color: product
                        .isOutOfStock
                        ? AppTheme.border
                        : AppTheme.primary,
                    width: 0.8,
                  ),
                  shape:
                  const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.zero,
                  ),
                  padding:
                  EdgeInsets.zero,
                ),
                child: Text(
                  product.isOutOfStock
                      ? 'SOLD OUT'
                      : 'ADD TO BAG',
                  style:
                  const TextStyle(
                    fontSize: 9,
                    fontWeight:
                    FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // GRID PRODUCT CARD
  // ------------------------------------------------------------

  Widget _productGridCard(ProductModel product,) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.product,
          arguments: product,
        );
      },
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration:
                  BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color:
                      AppTheme.border,
                      width: 0.8,
                    ),
                  ),
                  clipBehavior:
                  Clip.antiAlias,
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context,
                        error,
                        stackTrace,) {
                      return const Center(
                        child: Icon(
                          Icons
                              .image_not_supported_outlined,
                          size: 30,
                          color:
                          AppTheme
                              .textMuted,
                        ),
                      );
                    },
                  ),
                ),
                if (product.isSale)
                  Positioned(
                    top: 8,
                    left: 8,
                    child:
                    _productBadge(
                      'SALE',
                      black: true,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight:
              FontWeight.w500,
              color: AppTheme.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Rs. ${product.finalPrice.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight:
              FontWeight.w700,
              color:
              AppTheme.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _productBadge(String text, {
    required bool black,
  }) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      color: black
          ? AppTheme.primary
          : AppTheme.goldTint,
      child: Text(
        text,
        style: TextStyle(
          color: black
              ? Colors.white
              : AppTheme.gold,
          fontSize: 8,
          fontWeight:
          FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // EDITORIAL
  // ------------------------------------------------------------

  Widget _buildEditorialSection() {
    return Container(
      margin:
      const EdgeInsets.fromLTRB(
        18,
        38,
        18,
        0,
      ),
      padding:
      const EdgeInsets.all(25),
      color: AppTheme.creamDark,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'THE FASHLAB STUDIO EDIT',
            style: TextStyle(
              fontSize: 9,
              fontWeight:
              FontWeight.w600,
              letterSpacing: 1.8,
              color: AppTheme.gold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Made for Moments\nThat Matter',
            style: TextStyle(
              fontSize: 27,
              height: 1.1,
              fontWeight:
              FontWeight.w300,
              color:
              AppTheme.primaryDark,
            ),
          ),
          const SizedBox(height: 13),
          const Text(
            'Thoughtfully designed pieces brought together with elegance, comfort and contemporary style.',
            style: TextStyle(
              fontSize: 11,
              height: 1.6,
              color:
              AppTheme.textLight,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _showFilterSheet,
            child: const Text(
              'DISCOVER THE COLLECTION',
              style: TextStyle(
                fontSize: 9,
                fontWeight:
                FontWeight.w700,
                letterSpacing: 1,
                color:
                AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // WHY US
  // ------------------------------------------------------------

  Widget _buildWhyUs() {
    return Container(
      margin:
      const EdgeInsets.only(
        top: 38,
      ),
      padding:
      const EdgeInsets.fromLTRB(
        18,
        25,
        18,
        25,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'WHY CHOOSE US',
            style: TextStyle(
              fontSize: 9,
              fontWeight:
              FontWeight.w600,
              letterSpacing: 1.8,
              color: AppTheme.gold,
            ),
          ),
          const SizedBox(height: 20),
          _whyItem(
            Icons
                .workspace_premium_outlined,
            'Quality Fabrics',
            'Carefully selected fabrics for lasting comfort.',
          ),
          _whyItem(
            Icons.design_services_outlined,
            'Thoughtful Design',
            'Designed with attention to every detail.',
          ),
          _whyItem(
            Icons.local_shipping_outlined,
            'Easy Delivery',
            'Reliable delivery across Pakistan.',
          ),
          _whyItem(
            Icons.support_agent_outlined,
            'Customer Care',
            'We are here whenever you need us.',
          ),
        ],
      ),
    );
  }

  Widget _whyItem(IconData icon,
      String title,
      String description,) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 18,
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration:
            BoxDecoration(
              color:
              AppTheme.primaryTint,
              borderRadius:
              BorderRadius.circular(
                10,
              ),
            ),
            child: Icon(
              icon,
              size: 21,
              color:
              AppTheme.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                  const TextStyle(
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    AppTheme.ink,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  description,
                  style:
                  const TextStyle(
                    fontSize: 10,
                    color:
                    AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // SALE PRODUCTS
  // ------------------------------------------------------------

  Widget _buildSaleProducts() {
    return _buildProductHorizontalList(
      controller.saleProducts,
    );
  }

  // ------------------------------------------------------------
  // NEWSLETTER
  // ------------------------------------------------------------

  Widget _buildNewsletter() {
    return Container(
      margin:
      const EdgeInsets.fromLTRB(
        18,
        40,
        18,
        0,
      ),
      padding:
      const EdgeInsets.all(24),
      color: AppTheme.primaryDark,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'STAY IN THE LOOP',
            style: TextStyle(
              color: AppTheme.goldLight,
              fontSize: 9,
              fontWeight:
              FontWeight.w600,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Be the first to know.',
            style: TextStyle(
              color: AppTheme.cream,
              fontSize: 23,
              fontWeight:
              FontWeight.w300,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Get updates about new collections and exclusive offers.',
            style: TextStyle(
              color: AppTheme.goldTint,
              fontSize: 10,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Obx(() {
            return Container(
              height: 45,
              padding:
              const EdgeInsets.only(
                left: 14,
                right: 5,
              ),
              decoration:
              BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(
                  3,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        newsletterEmail
                            .value = value;
                      },
                      keyboardType:
                      TextInputType
                          .emailAddress,
                      textInputAction:
                      TextInputAction.done,
                      style:
                      const TextStyle(
                        color:
                        AppTheme.ink,
                        fontSize: 11,
                      ),
                      decoration:
                      const InputDecoration(
                        hintText:
                        'Your email address',
                        hintStyle:
                        TextStyle(
                          color: AppTheme
                              .textMuted,
                          fontSize: 11,
                        ),
                        border:
                        InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap:
                    isNewsletterLoading
                        .value
                        ? null
                        : _subscribeNewsletter,
                    child: Padding(
                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child:
                      isNewsletterLoading
                          .value
                          ? const SizedBox(
                        height: 17,
                        width: 17,
                        child:
                        CircularProgressIndicator(
                          strokeWidth:
                          1.5,
                          color:
                          AppTheme
                              .primary,
                        ),
                      )
                          : const Text(
                        'JOIN',
                        style:
                        TextStyle(
                          color:
                          AppTheme
                              .primary,
                          fontSize:
                          10,
                          fontWeight:
                          FontWeight
                              .w700,
                          letterSpacing:
                          1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _subscribeNewsletter() async {
    final email =
    newsletterEmail.value.trim();

    if (email.isEmpty) {
      Get.snackbar(
        'Email Required',
        'Please enter your email address.',
        snackPosition:
        SnackPosition.BOTTOM,
        duration:
        const Duration(seconds: 2),
      );
      return;
    }

    final emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailRegex.hasMatch(email)) {
      Get.snackbar(
        'Invalid Email',
        'Please enter a valid email address.',
        snackPosition:
        SnackPosition.BOTTOM,
        duration:
        const Duration(seconds: 2),
      );
      return;
    }

    try {
      isNewsletterLoading.value =
      true;

      final response =
      await ApiService.post(
        '/newsletter',
        body: {
          'email': email,
        },
      );

      final success =
          response['success'] == true;

      final message =
          response['message']
              ?.toString() ??
              (success
                  ? 'You are subscribed successfully.'
                  : 'Unable to subscribe right now.');

      Get.snackbar(
        success
            ? 'Newsletter'
            : 'Subscription Failed',
        message,
        snackPosition:
        SnackPosition.BOTTOM,
        duration:
        const Duration(seconds: 3),
      );

      if (success) {
        newsletterEmail.value = '';
      }
    } catch (e) {
      Get.snackbar(
        'Something went wrong',
        'Unable to subscribe right now. Please try again.',
        snackPosition:
        SnackPosition.BOTTOM,
        duration:
        const Duration(seconds: 3),
      );
    } finally {
      isNewsletterLoading.value =
      false;
    }
  }

  // ------------------------------------------------------------
  // SERVICES
  // ------------------------------------------------------------

  Widget _buildServiceStrip() {
    return Padding(
      padding:
      const EdgeInsets.fromLTRB(
        18,
        30,
        18,
        0,
      ),
      child: Column(
        children: [
          _serviceItem(
            Icons.payments_outlined,
            'Cash on Delivery',
          ),
          _serviceItem(
            Icons.local_shipping_outlined,
            'Free Delivery above Rs. 8,000',
          ),
          _serviceItem(
            Icons.swap_horiz_rounded,
            'Easy Exchange within 7 days',
          ),
          _serviceItem(
            Icons.chat_outlined,
            'Order on WhatsApp',
          ),
        ],
      ),
    );
  }

  Widget _serviceItem(IconData icon,
      String title,) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 13,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: AppTheme.gold,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color:
              AppTheme.textLight,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // BOTTOM NAV
  // ------------------------------------------------------------

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: AppTheme.primary,
      unselectedItemColor: AppTheme.textMuted,
      selectedFontSize: 10,
      unselectedFontSize: 9,
      elevation: 8,
      onTap: (index) {
        switch (index) {
          case 0:
            break;

          case 1:
            Get.to(
                  () => ShopScreen(),
            );
            break;

          case 2:
            Get.toNamed(
              AppRoutes.wishlist,
            );
            break;

          case 3:
            Get.toNamed(
              AppRoutes.cart,
            );
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
          ),
          activeIcon: Icon(
            Icons.home_rounded,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.grid_view_outlined,
          ),
          activeIcon: Icon(
            Icons.grid_view_rounded,
          ),
          label: 'Shop',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.favorite_border_rounded,
          ),
          activeIcon: Icon(
            Icons.favorite_rounded,
          ),
          label: 'Wishlist',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.shopping_bag_outlined,
          ),
          activeIcon: Icon(
            Icons.shopping_bag_rounded,
          ),
          label: 'Bag',
        ),
      ],
    );
  }
}