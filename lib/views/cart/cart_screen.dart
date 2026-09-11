import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_theme.dart';
import '../../controllers/cart_controller.dart';
import '../../models/cart_model.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final CartController controller = Get.put(
    CartController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),

        title: const Text(
          'YOUR BAG',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorState();
        }

        if (controller.isEmpty) {
          return _buildEmptyCart();
        }

        return RefreshIndicator(
          onRefresh: controller.refreshCart,

          child: ListView(
            physics:
            const AlwaysScrollableScrollPhysics(),

            padding: const EdgeInsets.fromLTRB(
              16,
              10,
              16,
              140,
            ),

            children: [
              _buildItemCount(),

              const SizedBox(height: 20),

              ...controller.cartItems.map(
                    (item) => _buildCartItem(item),
              ),

              const SizedBox(height: 24),

              _buildOrderSummary(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildItemCount() {
    return Text(
      '${controller.itemCount} '
          '${controller.itemCount == 1 ? 'ITEM' : 'ITEMS'}',
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: AppTheme.textSecondary,
      ),
    );
  }

  Widget _buildCartItem(
      CartItemModel item,
      ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(4),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          ClipRRect(
            borderRadius:
            BorderRadius.circular(2),

            child: Image.network(
              item.image,

              width: 100,
              height: 125,

              fit: BoxFit.cover,

              errorBuilder: (
                  context,
                  error,
                  stackTrace,
                  ) {
                return Container(
                  width: 100,
                  height: 125,
                  color: Colors.grey.shade100,

                  child: const Icon(
                    Icons.image_not_supported_outlined,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: SizedBox(
              height: 125,

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        child: Text(
                          item.name,

                          maxLines: 2,

                          overflow:
                          TextOverflow.ellipsis,

                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight:
                            FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ),

                      const SizedBox(width: 6),

                      GestureDetector(
                        onTap:
                        controller.isRemoving.value
                            ? null
                            : () =>
                            controller.removeItem(
                              item,
                            ),

                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color:
                          Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),

                  if (item.variantLabel != null &&
                      item.variantLabel!
                          .trim()
                          .isNotEmpty) ...[
                    const SizedBox(height: 5),

                    Text(
                      item.variantLabel!,

                      style: TextStyle(
                        fontSize: 11,
                        color:
                        AppTheme.textSecondary,
                      ),
                    ),
                  ],

                  const Spacer(),

                  Text(
                    item.formattedUnitPrice,

                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      _quantityButton(
                        icon: Icons.remove,

                        onTap:
                        item.quantity > 1 &&
                            !controller
                                .isUpdating
                                .value
                            ? () => controller
                            .decreaseQuantity(
                          item,
                        )
                            : null,
                      ),

                      Padding(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 14,
                        ),

                        child: Text(
                          '${item.quantity}',

                          style:
                          const TextStyle(
                            fontSize: 13,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),

                      _quantityButton(
                        icon: Icons.add,

                        onTap:
                        item.quantity <
                            item.maxQuantity &&
                            !controller
                                .isUpdating
                                .value
                            ? () => controller
                            .increaseQuantity(
                          item,
                        )
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 30,
        height: 30,

        alignment: Alignment.center,

        decoration: BoxDecoration(
          border: Border.all(
            color: onTap == null
                ? Colors.grey.shade200
                : Colors.grey.shade300,
          ),
        ),

        child: Icon(
          icon,

          size: 15,

          color: onTap == null
              ? Colors.grey.shade300
              : AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(4),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          const Text(
            'ORDER SUMMARY',

            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 18),

          _summaryRow(
            'Subtotal',
            'Rs. ${controller.subtotal.value.toStringAsFixed(0)}',
          ),

          const SizedBox(height: 10),

          _summaryRow(
            'Shipping',
            controller.shipping.value == 0
                ? 'Free'
                : 'Rs. ${controller.shipping.value.toStringAsFixed(0)}',
          ),

          const SizedBox(height: 10),

          _summaryRow(
            'Discount',
            'Rs. ${controller.discount.value.toStringAsFixed(0)}',
          ),

          const Padding(
            padding:
            EdgeInsets.symmetric(
              vertical: 16,
            ),

            child: Divider(),
          ),

          _summaryRow(
            'Total',
            'Rs. ${controller.total.value.toStringAsFixed(0)}',
            isTotal: true,
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,

            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(
                  AppRoutes.checkout,
                );
              },

              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                AppTheme.primary,

                foregroundColor:
                Colors.white,

                elevation: 0,

                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(2),
                ),
              ),

              child: const Text(
                'PROCEED TO CHECKOUT',

                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                  FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
      String title,
      String value, {
        bool isTotal = false,
      }) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

      children: [
        Text(
          title,

          style: TextStyle(
            fontSize: isTotal ? 14 : 13,

            fontWeight: isTotal
                ? FontWeight.w700
                : FontWeight.w400,

            color:
            AppTheme.textSecondary,
          ),
        ),

        Text(
          value,

          style: TextStyle(
            fontSize: isTotal ? 15 : 13,

            fontWeight:
            FontWeight.w700,

            color:
            AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 24),

            const Text(
              'YOUR BAG IS EMPTY',

              style: TextStyle(
                fontSize: 16,
                fontWeight:
                FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Discover our latest collection\n'
                  'and find something you love.',

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 13,
                height: 1.6,
                color:
                AppTheme.textSecondary,
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: 190,
              height: 48,

              child: ElevatedButton(
                onPressed: () =>
                    Get.back(),

                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  AppTheme.primary,

                  foregroundColor:
                  Colors.white,

                  elevation: 0,

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(2),
                  ),
                ),

                child: const Text(
                  'CONTINUE SHOPPING',

                  style: TextStyle(
                    fontSize: 10,
                    fontWeight:
                    FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 55,
              color: Colors.grey.shade500,
            ),

            const SizedBox(height: 18),

            const Text(
              'UNABLE TO LOAD BAG',

              style: TextStyle(
                fontSize: 15,
                fontWeight:
                FontWeight.w700,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              controller.errorMessage.value,

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 12,
                color:
                AppTheme.textSecondary,
              ),
            ),

            const SizedBox(height: 22),

            OutlinedButton(
              onPressed:
              controller.fetchCart,

              child: const Text(
                'TRY AGAIN',
              ),
            ),
          ],
        ),
      ),
    );
  }
}