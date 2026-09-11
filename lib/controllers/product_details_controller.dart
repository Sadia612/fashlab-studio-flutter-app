import 'package:get/get.dart';

import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductDetailsController extends GetxController {
  final Rx<ProductModel?> product =
  Rx<ProductModel?>(null);

  final RxInt selectedImageIndex = 0.obs;

  final RxString selectedSize = ''.obs;

  final RxString selectedColor = ''.obs;

  final RxInt quantity = 1.obs;

  final RxBool isFavorite = false.obs;

  final RxBool isTogglingFavorite = false.obs;

  final RxBool isAddingToCart = false.obs;

  void setProduct(ProductModel newProduct) {
    product.value = newProduct;

    if (newProduct.sizes.isNotEmpty) {
      selectedSize.value = newProduct.sizes.first;
    }

    if (newProduct.colors.isNotEmpty) {
      selectedColor.value = newProduct.colors.first;
    }
  }

  void changeImage(int index) {
    selectedImageIndex.value = index;
  }

  void selectSize(String size) {
    selectedSize.value = size;
  }

  void selectColor(String color) {
    selectedColor.value = color;
  }

  void increaseQuantity() {
    if (product.value == null) return;

    if (quantity.value < product.value!.stockQuantity) {
      quantity.value++;
    }
  }

  void decreaseQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  Future<void> toggleFavorite() async {
    if (isTogglingFavorite.value) return;

    isTogglingFavorite.value = true;

    try {
      if (product.value == null) return;

      final response = await ApiService.post(
        '/wishlist/toggle',
        body: {
          'product_id': product.value!.id,
        },
      );

      if (response['success'] == true) {
        final saved =
            response['data']?['saved'] == true ||
                response['data']?['saved']?.toString() == '1' ||
                response['data']?['saved']?.toString() == 'true';

        isFavorite.value = saved;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not update wishlist. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isTogglingFavorite.value = false;
    }
  }

  Future<void> addToCart() async {
    if (product.value == null) return;

    if (product.value!.isOutOfStock) {
      Get.snackbar(
        'Unavailable',
        'This product is currently out of stock.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isAddingToCart.value) return;

    try {
      isAddingToCart.value = true;

      final response = await ApiService.post(
        '/cart/items',
        body: {
          'product_id': product.value!.id,
          'quantity': quantity.value,
        },
      );

      print('ADD TO CART RESPONSE: $response');

      if (response['success'] == true) {
        Get.snackbar(
          'Added to Cart',
          '${product.value!.name} added to your cart.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Unable to Add',
          response['message']?.toString() ??
              'Could not add product to cart.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('ADD TO CART ERROR: $e');

      Get.snackbar(
        'Error',
        'Could not add product to cart. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isAddingToCart.value = false;
    }
  }
}