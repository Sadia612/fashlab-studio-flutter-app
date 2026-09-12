import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ecommerce_app/controllers/product_details_controller.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:ecommerce_app/app/theme/app_theme.dart';
import 'package:ecommerce_app/app/routes/app_routes.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel? product;

  ProductDetailsScreen({
    super.key,
    this.product,
  });

  final ProductDetailsController controller =
  Get.put(ProductDetailsController());

  @override
  Widget build(BuildContext context) {
    final ProductModel currentProduct =
        product ?? (Get.arguments as ProductModel);

    controller.setProduct(currentProduct);

    return Scaffold(
      backgroundColor: AppTheme.cream,

      appBar: AppBar(
        backgroundColor: AppTheme.cream,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 20,
        title: const Text(
          'FASHLAB STUDIO',
          style: TextStyle(
            color: AppTheme.ink,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.2,
          ),
        ),
        actions: [
          Obx(
                () => IconButton(
              onPressed: () => controller.toggleFavorite(),
              icon: Icon(
                controller.isFavorite.value
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: controller.isFavorite.value
                    ? AppTheme.primary
                    : AppTheme.ink,
                size: 23,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------------------------------------------------
            // PRODUCT IMAGE
            // ----------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 430,
                  width: double.infinity,
                  color: const Color(0xFFEAE5DD),
                  child: Image.network(
                    currentProduct.image,
                    fit: BoxFit.cover,
                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 45,
                          color: AppTheme.textMuted,
                        ),
                      );
                    },
                    loadingBuilder: (
                        context,
                        child,
                        loadingProgress,
                        ) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return const Center(
                        child: SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: AppTheme.ink,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ----------------------------------------------------------
            // PRODUCT INFORMATION
            // ----------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CATEGORY
                  if (currentProduct.category.isNotEmpty)
                    Text(
                      currentProduct.category
                          .split(',')
                          .first
                          .trim()
                          .toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),

                  const SizedBox(height: 8),

                  // PRODUCT NAME
                  Text(
                    currentProduct.name,
                    style: const TextStyle(
                      color: AppTheme.ink,
                      fontSize: 25,
                      height: 1.2,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // PRICE
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Rs. ${currentProduct.finalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      if (currentProduct.onSale) ...[
                        const SizedBox(width: 12),
                        Text(
                          'Rs. ${currentProduct.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],

                      const Spacer(),

                      if (currentProduct.isNew)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.ink,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Container(
                    height: 1,
                    color: const Color(0xFFE1DCD4),
                  ),

                  const SizedBox(height: 22),

                  // ----------------------------------------------------
                  // FABRIC
                  // ----------------------------------------------------
                  if (currentProduct.fabric.isNotEmpty) ...[
                    _detailRow(
                      title: 'FABRIC',
                      value: currentProduct.fabric,
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ----------------------------------------------------
                  // COLORS
                  // ----------------------------------------------------
                  if (currentProduct.colors.isNotEmpty) ...[
                    const Text(
                      'COLOR',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: currentProduct.colors.map(
                            (color) {
                          return GestureDetector(
                            onTap: () {
                              controller.selectColor(color);
                            },
                            child: Obx(
                                  () {
                                final bool selected =
                                    controller.selectedColor.value ==
                                        color;

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 9,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? AppTheme.ink
                                        : Colors.white,
                                    border: Border.all(
                                      color: selected
                                          ? AppTheme.ink
                                          : const Color(0xFFDCD6CC),
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(2),
                                  ),
                                  child: Text(
                                    color,
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : AppTheme.ink,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ).toList(),
                    ),

                    const SizedBox(height: 22),
                  ],

                  // ----------------------------------------------------
                  // SIZE
                  // ----------------------------------------------------
                  const Text(
                    'SELECT SIZE',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _buildSizeSelector(currentProduct),

                  const SizedBox(height: 24),

                  // ----------------------------------------------------
                  // DESCRIPTION
                  // ----------------------------------------------------
                  if (currentProduct.description != null &&
                      currentProduct.description!.isNotEmpty) ...[
                    const Text(
                      'DESCRIPTION',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      currentProduct.description!,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 14,
                        height: 1.7,
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],

                  Container(
                    height: 1,
                    color: const Color(0xFFE1DCD4),
                  ),

                  const SizedBox(height: 20),

                  // ----------------------------------------------------
                  // QUANTITY
                  // ----------------------------------------------------
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'QUANTITY',
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                        ),
                      ),

                      Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFFDCD6CC),
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 42,
                              ),
                              onPressed: () {
                                controller.decreaseQuantity();
                              },
                              icon: const Icon(
                                Icons.remove,
                                size: 16,
                                color: AppTheme.ink,
                              ),
                            ),

                            Obx(
                                  () => SizedBox(
                                width: 30,
                                child: Center(
                                  child: Text(
                                    '${controller.quantity.value}',
                                    style: const TextStyle(
                                      color: AppTheme.ink,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 42,
                              ),
                              onPressed: () {
                                controller.increaseQuantity();
                              },
                              icon: const Icon(
                                Icons.add,
                                size: 16,
                                color: AppTheme.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),
                ],
              ),
            ),
          ],
        ),
      ),

      // --------------------------------------------------------------
      // BOTTOM ACTIONS
      // --------------------------------------------------------------
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            14,
          ),
          decoration: BoxDecoration(
            color: AppTheme.cream,
            border: const Border(
              top: BorderSide(
                color: Color(0xFFE1DCD4),
              ),
            ),
          ),
          child: Row(
            children: [
              // --------------------------------------------------------
              // ADD TO BAG
              // --------------------------------------------------------
              Expanded(
                child: Obx(
                      () => SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      onPressed:
                      currentProduct.inStock &&
                          !controller.isAddingToCart.value
                          ? () => controller.addToCart()
                          : null,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.ink,
                        side: const BorderSide(
                          color: AppTheme.ink,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      child: controller.isAddingToCart.value
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.8,
                          color: AppTheme.ink,
                        ),
                      )
                          : Text(
                        currentProduct.inStock
                            ? 'ADD TO BAG'
                            : 'OUT OF STOCK',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // --------------------------------------------------------
              // BUY NOW
              // DIRECTLY GOES TO ORDER SCREEN
              // --------------------------------------------------------
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: currentProduct.inStock
                        ? () {
                      Get.toNamed(
                        AppRoutes.checkout,
                        arguments: {
                          'product': currentProduct,
                          'quantity': controller.quantity.value,
                          'size': controller.selectedSize.value,
                          'color': controller.selectedColor.value,
                        },
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: const Text(
                      'BUY NOW',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // SIZE SELECTOR
  // ------------------------------------------------------------------

  Widget _buildSizeSelector(ProductModel product) {
    final List<String> sizes = product.sizes.isNotEmpty
        ? product.sizes
        : ['SMALL', 'LARGE', 'XL'];

    return Obx(
          () => Wrap(
        spacing: 10,
        runSpacing: 10,
        children: sizes.map(
              (size) {
            final String displaySize =
            size.trim().toUpperCase();

            final bool selected =
                controller.selectedSize.value.toUpperCase() ==
                    displaySize;

            return GestureDetector(
              onTap: () {
                controller.selectSize(size);
              },
              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 180,
                ),
                width: 78,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? AppTheme.ink
                      : Colors.white,
                  border: Border.all(
                    color: selected
                        ? AppTheme.ink
                        : const Color(0xFFDCD6CC),
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  displaySize,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : AppTheme.ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  // ------------------------------------------------------------------
  // DETAIL ROW
  // ------------------------------------------------------------------

  Widget _detailRow({
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 75,
          child: Text(
            title,
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppTheme.ink,
              fontSize: 13,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}