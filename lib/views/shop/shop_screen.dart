import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_theme.dart';
import '../../controllers/shop_controller.dart';
import '../../models/product_model.dart';

class ShopScreen extends StatelessWidget {
  ShopScreen({super.key});

  final ShopController controller =
  Get.put(ShopController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: SafeArea(
        child: Obx(() {
          return CustomScrollView(
            physics:
            const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(),
              ),

              SliverToBoxAdapter(
                child: _buildIntro(),
              ),

              SliverToBoxAdapter(
                child: _buildFabricSection(),
              ),

              SliverToBoxAdapter(
                child: _buildPriceSection(),
              ),

              SliverToBoxAdapter(
                child: _buildFeaturedSection(),
              ),

              SliverToBoxAdapter(
                child: _buildResultsHeader(),
              ),

              if (controller.isLoading.value)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(
                      vertical: 55,
                    ),
                    child: Center(
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                )
              else if (controller
                  .errorMessage.value
                  .isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildError(),
                )
              else if (controller.products.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(
                        vertical: 55,
                      ),
                      child: Center(
                        child: Text(
                          'No products found.',
                          style: TextStyle(
                            color:
                            AppTheme.textLight,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding:
                    const EdgeInsets.fromLTRB(
                      18,
                      0,
                      18,
                      35,
                    ),
                    sliver: SliverGrid(
                      delegate:
                      SliverChildBuilderDelegate(
                            (context, index) {
                          return _productCard(
                            controller.products[index],
                          );
                        },
                        childCount:
                        controller.products.length,
                      ),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 18,
                        childAspectRatio: 0.58,
                      ),
                    ),
                  ),
            ],
          );
        }),
      ),
      bottomNavigationBar:
      _buildBottomNavigation(),
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        15,
        18,
        8,
      ),
      child: Row(
        children: [
          _iconButton(
            Icons.arrow_back_rounded,
                () {
              Get.offNamed(AppRoutes.home);
            },
          ),

          const SizedBox(width: 13),

          const Expanded(
            child: Text(
              'SHOP',
              style: TextStyle(
                color: AppTheme.primaryDark,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
              ),
            ),
          ),

          _iconButton(
            Icons.favorite_border_rounded,
                () {
              Get.toNamed(AppRoutes.wishlist);
            },
          ),

          const SizedBox(width: 8),

          _iconButton(
            Icons.shopping_bag_outlined,
                () {
              Get.toNamed(AppRoutes.cart);
            },
          ),
        ],
      ),
    );
  }

  Widget _iconButton(
      IconData icon,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius:
      BorderRadius.circular(12),
      child: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.border,
            width: 0.8,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: AppTheme.ink,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // INTRO
  // ------------------------------------------------------------

  Widget _buildIntro() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        18,
        18,
        4,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'Find Your Style',
            style: TextStyle(
              color: AppTheme.primaryDark,
              fontSize: 28,
              fontWeight: FontWeight.w300,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Explore fabrics, price ranges and '
                'our featured collections.',
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 11,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // FABRIC
  // ------------------------------------------------------------

  Widget _buildFabricSection() {
    return _section(
      title: 'Shop By Fabric',
      children: [
        _horizontalOptions([
          _option(
            'Lawn',
            Icons.local_florist_outlined,
                () {
              controller.loadFabric(
                'Lawn',
                category: 'lawn-collection',
              );
            },
          ),
          _option(
            'Cotton',
            Icons.texture_outlined,
                () {
              controller.loadFabric(
                'Cotton',
                category: 'cotton-collection',
              );
            },
          ),
          _option(
            'Chiffon',
            Icons.layers_outlined,
                () {
              controller.loadFabric(
                'Chiffon',
                query: 'chiffon',
              );
            },
          ),
          _option(
            'Silk',
            Icons.auto_awesome_outlined,
                () {
              controller.loadFabric(
                'Silk',
                query: 'silk',
              );
            },
          ),
          _option(
            'Linen',
            Icons.grid_4x4_outlined,
                () {
              controller.loadFabric(
                'Linen',
                category: 'linen-collection',
              );
            },
          ),
          _option(
            'Velvet',
            Icons.blur_on_outlined,
                () {
              controller.loadFabric(
                'Velvet',
                query: 'velvet',
              );
            },
          ),
          _option(
            'Khaddar',
            Icons.checkroom_outlined,
                () {
              controller.loadFabric(
                'Khaddar',
                query: 'khaddar',
              );
            },
          ),
        ]),
      ],
    );
  }

  // ------------------------------------------------------------
  // PRICE
  // ------------------------------------------------------------

  Widget _buildPriceSection() {
    return _section(
      title: 'Shop By Price',
      children: [
        _priceTile(
          'Under Rs. 5,000',
          'under-5000',
        ),
        _priceTile(
          'Rs. 5,000 – Rs. 10,000',
          '5000-10000',
        ),
        _priceTile(
          'Rs. 10,000 – Rs. 15,000',
          '10000-15000',
        ),
        _priceTile(
          'Above Rs. 15,000',
          'over-15000',
        ),
      ],
    );
  }

  Widget _priceTile(
      String title,
      String price,
      ) {
    return GestureDetector(
      onTap: () {
        controller.loadPrice(
          title,
          price,
        );
      },
      child: Container(
        width: double.infinity,
        margin:
        const EdgeInsets.only(bottom: 8),
        padding:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: AppTheme.border,
            width: 0.8,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.sell_outlined,
              size: 18,
              color: AppTheme.gold,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppTheme.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: AppTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // FEATURED
  // ------------------------------------------------------------

  Widget _buildFeaturedSection() {
    return _section(
      title: 'Featured',
      children: [
        _featuredTile(
          'New Arrivals',
          'Latest styles and new pieces',
          Icons.new_releases_outlined,
              () {
            controller.loadFeatured(
              'New Arrivals',
              sort: 'newest',
            );
          },
        ),
        _featuredTile(
          'Best Sellers',
          'Loved by our customers',
          Icons.star_border_rounded,
              () {
            controller.loadFeatured(
              'Best Sellers',
              sort: 'best_selling',
            );
          },
        ),
        _featuredTile(
          'Trending',
          'Discover what is trending',
          Icons.trending_up_rounded,
              () {
            controller.loadFeatured(
              'Trending',
              sort: 'newest',
            );
          },
        ),
        _featuredTile(
          'Limited Edition',
          'Exclusive selected pieces',
          Icons.diamond_outlined,
              () {
            controller.loadFeatured(
              'Limited Edition',
              sort: 'featured',
              featured: true,
            );
          },
        ),
        _featuredTile(
          'Sale',
          'Elegant styles at special prices',
          Icons.local_offer_outlined,
              () {
            controller.loadFeatured(
              'Sale',
              sale: true,
            );
          },
        ),
      ],
    );
  }

  Widget _featuredTile(
      String title,
      String subtitle,
      IconData icon,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin:
        const EdgeInsets.only(bottom: 8),
        padding:
        const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: AppTheme.border,
            width: 0.8,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: AppTheme.cream,
                border: Border.all(
                  color: AppTheme.border,
                ),
              ),
              child: Icon(
                icon,
                color: AppTheme.gold,
                size: 20,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.ink,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: AppTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SECTION
  // ------------------------------------------------------------

  Widget _section({
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        30,
        18,
        0,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.primaryDark,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 13),
          ...children,
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // FABRIC HORIZONTAL OPTIONS
  // ------------------------------------------------------------

  Widget _horizontalOptions(
      List<Widget> children,
      ) {
    return SizedBox(
      height: 92,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics:
        const BouncingScrollPhysics(),
        children: children,
      ),
    );
  }

  Widget _option(
      String title,
      IconData icon,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 82,
        margin:
        const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: AppTheme.border,
            width: 0.8,
          ),
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppTheme.gold,
              size: 23,
            ),
            const SizedBox(height: 9),
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.ink,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // RESULTS HEADER
  // ------------------------------------------------------------

  Widget _buildResultsHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        34,
        18,
        15,
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
                  controller.selectedTitle.value
                      .toUpperCase(),
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${controller.products.length} products',
                  style: const TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap:
            controller.loadAllProducts,
            child: const Text(
              'VIEW ALL',
              style: TextStyle(
                color: AppTheme.gold,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // ERROR
  // ------------------------------------------------------------

  Widget _buildError() {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 40,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 30,
            color: AppTheme.textMuted,
          ),
          const SizedBox(height: 12),
          Text(
            controller.errorMessage.value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed:
            controller.loadAllProducts,
            child: const Text(
              'TRY AGAIN',
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // PRODUCT CARD
  // ------------------------------------------------------------

  Widget _productCard(
      ProductModel product,
      ) {
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
                  decoration: BoxDecoration(
                    color: AppTheme.creamDark,
                    border: Border.all(
                      color: AppTheme.border,
                      width: 0.7,
                    ),
                  ),
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stack) {
                      return const Center(
                        child: Icon(
                          Icons
                              .image_not_supported_outlined,
                          size: 30,
                          color:
                          AppTheme.textMuted,
                        ),
                      );
                    },
                    loadingBuilder: (
                        context,
                        child,
                        progress,
                        ) {
                      if (progress == null) {
                        return child;
                      }

                      return const Center(
                        child: SizedBox(
                          height: 22,
                          width: 22,
                          child:
                          CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color:
                            AppTheme.gold,
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
                    child: _badge(
                      'SALE',
                      true,
                    ),
                  )
                else if (product.isNew)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: _badge(
                      'NEW',
                      false,
                    ),
                  ),

                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    height: 34,
                    width: 34,
                    decoration:
                    const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      size: 17,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Text(
            product.category.isNotEmpty
                ? product.category
                : 'FASHLAB STUDIO',
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.gold,
              fontSize: 8,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.7,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            product.name,
            maxLines: 2,
            overflow:
            TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.ink,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              Text(
                'Rs. ${product.finalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppTheme.primaryDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),

              if (product.isSale) ...[
                const SizedBox(width: 7),
                Text(
                  'Rs. ${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 9,
                    decoration:
                    TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(
      String text,
      bool black,
      ) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      color: black
          ? AppTheme.primaryDark
          : AppTheme.cream,
      child: Text(
        text,
        style: TextStyle(
          color: black
              ? Colors.white
              : AppTheme.primary,
          fontSize: 8,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.7,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // BOTTOM NAVIGATION
  // ------------------------------------------------------------

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: 1,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: AppTheme.primary,
      unselectedItemColor:
      AppTheme.textMuted,
      selectedFontSize: 10,
      unselectedFontSize: 9,
      elevation: 8,
      onTap: (index) {
        switch (index) {
          case 0:
            Get.offNamed(
              AppRoutes.home,
            );
            break;

          case 1:
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