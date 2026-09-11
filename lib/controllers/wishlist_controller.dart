import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/api_service.dart';

class WishlistController extends GetxController {
  final wishlistProducts = <ProductModel>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response =
      await ApiService.get('/wishlist');

      debugPrint(
        'WISHLIST API RESPONSE: $response',
      );

      if (response['success'] == true) {
        final data = response['data'];

        List rawItems = [];

        if (data is Map) {
          rawItems =
              data['items'] ??
                  data['products'] ??
                  data['wishlist'] ??
                  [];
        } else if (data is List) {
          rawItems = data;
        }

        final List<ProductModel> parsedProducts = [];

        for (final item in rawItems) {
          try {
            if (item is Map) {
              final map =
              Map<String, dynamic>.from(item);

              if (map['product'] is Map) {
                parsedProducts.add(
                  ProductModel.fromJson(
                    Map<String, dynamic>.from(
                      map['product'],
                    ),
                  ),
                );
              } else {
                parsedProducts.add(
                  ProductModel.fromJson(map),
                );
              }
            }
          } catch (e) {
            debugPrint(
              'Wishlist item parse error: $e',
            );
          }
        }

        wishlistProducts.assignAll(
          parsedProducts,
        );
      } else {
        errorMessage.value =
            response['message']?.toString() ??
                'Unable to load wishlist.';
      }
    } catch (e) {
      debugPrint(
        'Wishlist fetch error: $e',
      );

      errorMessage.value =
      'Unable to load wishlist.';
    } finally {
      isLoading.value = false;
    }
  }

  bool isInWishlist(int productId) {
    return wishlistProducts.any(
          (product) => product.id == productId,
    );
  }

  Future<bool> toggleWishlist(
      ProductModel product,
      ) async {
    try {
      final response =
      await ApiService.post(
        '/wishlist/toggle',
        body: {
          'product_id': product.id,
        },
      );

      debugPrint(
        'WISHLIST TOGGLE RESPONSE: $response',
      );

      if (response['success'] == true) {
        final dynamic savedValue =
        response['data']?['saved'];

        final bool isSaved =
            savedValue == true ||
                savedValue.toString() == 'true' ||
                savedValue.toString() == '1';

        if (isSaved) {
          if (!wishlistProducts.any(
                (item) => item.id == product.id,
          )) {
            wishlistProducts.add(product);
          }

          Get.snackbar(
            'Wishlist',
            '${product.name} saved to Wishlist.',
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
          );
        } else {
          wishlistProducts.removeWhere(
                (item) => item.id == product.id,
          );

          Get.snackbar(
            'Wishlist',
            '${product.name} removed from Wishlist.',
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
          );
        }

        // API se fresh data dobara load
        await fetchWishlist();

        return isSaved;
      }
    } catch (e) {
      debugPrint(
        'Wishlist toggle error: $e',
      );

      Get.snackbar(
        'Error',
        'Could not update wishlist. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }

    return isInWishlist(product.id);
  }

  bool isFavorite(int productId) {
    return wishlistProducts.any(
          (product) => product.id == productId,
    );
  }
}