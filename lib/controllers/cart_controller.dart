import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../models/cart_model.dart';
import '../services/api_service.dart';

class CartController extends GetxController {
  final cartItems = <CartItemModel>[].obs;

  final isLoading = false.obs;
  final isUpdating = false.obs;
  final isRemoving = false.obs;

  final errorMessage = ''.obs;

  final subtotal = 0.0.obs;
  final shipping = 0.0.obs;
  final discount = 0.0.obs;
  final total = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  // ============================================================
  // GET CART
  // ============================================================

  Future<void> fetchCart() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await ApiService.get('/cart');

      debugPrint(
        'CART API RESPONSE: $response',
      );

      if (response['success'] == true) {
        _updateCartFromResponse(response);
      } else {
        errorMessage.value =
            response['message']?.toString() ??
                'Unable to load cart.';
      }
    } catch (e) {
      debugPrint(
        'CART FETCH ERROR: $e',
      );

      errorMessage.value =
      'Unable to load cart. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // UPDATE LOCAL CART DATA FROM API
  // ============================================================

  void _updateCartFromResponse(
      Map<String, dynamic> response,
      ) {
    final data = response['data'] ?? {};

    final List items =
    data is Map ? (data['items'] ?? []) : [];

    cartItems.assignAll(
      items
          .map(
            (item) => CartItemModel.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList(),
    );

    final totals =
    data is Map ? (data['totals'] ?? {}) : {};

    subtotal.value =
        double.tryParse(
          totals['subtotal']?.toString() ?? '0',
        ) ??
            0;

    shipping.value =
        double.tryParse(
          totals['shipping']?.toString() ?? '0',
        ) ??
            0;

    discount.value =
        double.tryParse(
          totals['discount']?.toString() ?? '0',
        ) ??
            0;

    total.value =
        double.tryParse(
          totals['total']?.toString() ?? '0',
        ) ??
            0;
  }

  // ============================================================
  // UPDATE QUANTITY
  // ============================================================

  Future<void> updateQuantity(
      CartItemModel item,
      int newQuantity,
      ) async {
    if (newQuantity < 1) {
      return;
    }

    if (newQuantity > item.maxQuantity) {
      Get.snackbar(
        'Maximum Quantity',
        'Only ${item.maxQuantity} items are available.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    try {
      isUpdating.value = true;

      debugPrint(
        'UPDATING CART ITEM: ${item.key}',
      );

      final response = await ApiService.patch(
        '/cart/items',
        body: {
          'key': item.key,
          'quantity': newQuantity,
        },
      );

      debugPrint(
        'CART UPDATE RESPONSE: $response',
      );

      if (response['success'] == true) {
        _updateCartFromResponse(response);
      } else {
        Get.snackbar(
          'Unable to Update',
          response['message']?.toString() ??
              'Could not update quantity.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      debugPrint(
        'CART UPDATE ERROR: $e',
      );

      Get.snackbar(
        'Error',
        'Could not update quantity. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // ============================================================
  // INCREASE QUANTITY
  // ============================================================

  Future<void> increaseQuantity(
      CartItemModel item,
      ) async {
    if (item.quantity < item.maxQuantity) {
      await updateQuantity(
        item,
        item.quantity + 1,
      );
    } else {
      Get.snackbar(
        'Maximum Quantity',
        'Only ${item.maxQuantity} items are available.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  // ============================================================
  // DECREASE QUANTITY
  // ============================================================

  Future<void> decreaseQuantity(
      CartItemModel item,
      ) async {
    if (item.quantity > 1) {
      await updateQuantity(
        item,
        item.quantity - 1,
      );
    }
  }

  // ============================================================
  // REMOVE ITEM
  // ============================================================

  Future<void> removeItem(
      CartItemModel item,
      ) async {
    try {
      isRemoving.value = true;

      debugPrint(
        'REMOVING CART ITEM KEY: ${item.key}',
      );

      // Fashlab API preferred remove endpoint
      final response = await ApiService.post(
        '/cart/items/remove',
        body: {
          'key': item.key,
        },
      );

      debugPrint(
        'CART REMOVE RESPONSE: $response',
      );

      if (response['success'] == true) {
        _updateCartFromResponse(response);

        Get.snackbar(
          'Removed',
          '${item.name} has been removed from your bag.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      } else {
        Get.snackbar(
          'Unable to Remove',
          response['message']?.toString() ??
              'Could not remove item.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      debugPrint(
        'CART REMOVE ERROR: $e',
      );

      Get.snackbar(
        'Error',
        'Could not remove item. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isRemoving.value = false;
    }
  }

  // ============================================================
  // REFRESH CART
  // ============================================================

  Future<void> refreshCart() async {
    await fetchCart();
  }

  // ============================================================
  // CART ITEM COUNT
  // ============================================================

  int get itemCount {
    return cartItems.fold(
      0,
          (sum, item) => sum + item.quantity,
    );
  }

  // ============================================================
  // EMPTY CHECK
  // ============================================================

  bool get isEmpty {
    return cartItems.isEmpty;
  }
}