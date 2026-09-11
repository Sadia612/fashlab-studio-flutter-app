import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/cart_model.dart';
import '../services/api_service.dart';
import 'order_history_controller.dart';

class DeliveryOption {
  final String code;
  final String name;
  final String description;
  final double fee;
  final String formattedFee;
  final int freeAbove;
  final String estimatedDays;

  DeliveryOption({
    required this.code,
    required this.name,
    required this.description,
    required this.fee,
    required this.formattedFee,
    required this.freeAbove,
    required this.estimatedDays,
  });

  factory DeliveryOption.fromJson(
      Map<String, dynamic> json,
      ) {
    return DeliveryOption(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      fee: (json['fee'] ?? 0).toDouble(),
      formattedFee: json['formatted_fee']?.toString() ?? '',
      freeAbove: (json['free_above'] ?? 0).toInt(),
      estimatedDays: json['estimated_days']?.toString() ?? '',
    );
  }
}

class PaymentMethod {
  final String code;
  final String name;
  final bool enabled;

  PaymentMethod({
    required this.code,
    required this.name,
    required this.enabled,
  });

  factory PaymentMethod.fromJson(
      Map<String, dynamic> json,
      ) {
    return PaymentMethod(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      enabled: json['enabled'] == true,
    );
  }
}

class CheckoutController extends GetxController {
  // =========================
  // TEXT CONTROLLERS
  // =========================

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final postalCodeController = TextEditingController();
  final notesController = TextEditingController();

  // =========================
  // UI STATES
  // =========================

  final isLoading = false.obs;
  final isPlacingOrder = false.obs;
  final errorMessage = ''.obs;

  // =========================
  // CHECKOUT DATA
  // =========================

  final cartItems = <CartItemModel>[].obs;
  final deliveryOptions = <DeliveryOption>[].obs;
  final paymentMethods = <PaymentMethod>[].obs;

  // =========================
  // SELECTED OPTIONS
  // =========================

  final selectedDelivery = 'standard'.obs;
  final selectedPayment = 'cod'.obs;

  // =========================
  // TOTALS
  // =========================

  final subtotal = 0.0.obs;
  final shipping = 0.0.obs;
  final discount = 0.0.obs;
  final total = 0.0.obs;

  final formattedSubtotal = ''.obs;
  final formattedShipping = ''.obs;
  final formattedDiscount = ''.obs;
  final formattedTotal = ''.obs;

  final currency = 'Rs.'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCheckout();
  }

  // =========================
  // GET CHECKOUT DATA
  // =========================

  Future<void> fetchCheckout() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await ApiService.get('/checkout');

      debugPrint(
        'CHECKOUT API RESPONSE: $response',
      );

      if (response['success'] == true) {
        _parseCheckoutData(
          Map<String, dynamic>.from(
            response['data'] ?? {},
          ),
        );
      } else {
        errorMessage.value =
            response['message']?.toString() ??
                'Unable to load checkout.';
      }
    } catch (e) {
      debugPrint(
        'Checkout Error: $e',
      );

      errorMessage.value =
      'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // PARSE CHECKOUT RESPONSE
  // =========================

  void _parseCheckoutData(
      Map<String, dynamic> data,
      ) {
    // CART
    final cart = data['cart'];

    if (cart is Map) {
      final rawItems = cart['items'];

      if (rawItems is List) {
        cartItems.assignAll(
          rawItems
              .whereType<Map>()
              .map(
                (item) => CartItemModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
              .toList(),
        );
      }

      // TOTALS
      final totals = cart['totals'];

      if (totals is Map) {
        subtotal.value =
            (totals['subtotal'] ?? 0).toDouble();

        shipping.value =
            (totals['shipping'] ?? 0).toDouble();

        discount.value =
            (totals['discount'] ?? 0).toDouble();

        total.value =
            (totals['total'] ?? 0).toDouble();

        final formatted = totals['formatted'];

        if (formatted is Map) {
          formattedSubtotal.value =
              formatted['subtotal']?.toString() ?? '';

          formattedShipping.value =
              formatted['shipping']?.toString() ?? '';

          formattedDiscount.value =
              formatted['discount']?.toString() ?? '';

          formattedTotal.value =
              formatted['total']?.toString() ?? '';
        }
      }

      currency.value =
          cart['currency']?.toString() ?? 'Rs.';
    }

    // DELIVERY OPTIONS
    final rawDelivery = data['delivery_options'];

    if (rawDelivery is List) {
      deliveryOptions.assignAll(
        rawDelivery
            .whereType<Map>()
            .map(
              (item) => DeliveryOption.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
            .toList(),
      );
    }

    // PAYMENT METHODS
    final rawPayments = data['payment_methods'];

    if (rawPayments is List) {
      paymentMethods.assignAll(
        rawPayments
            .whereType<Map>()
            .map(
              (item) => PaymentMethod.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
            .where(
              (payment) => payment.enabled,
        )
            .toList(),
      );
    }

    // DEFAULT DELIVERY
    if (deliveryOptions.isNotEmpty) {
      final standardExists = deliveryOptions.any(
            (item) => item.code == 'standard',
      );

      if (standardExists) {
        selectedDelivery.value = 'standard';
      } else {
        selectedDelivery.value =
            deliveryOptions.first.code;
      }
    }

    // DEFAULT PAYMENT
    if (paymentMethods.isNotEmpty) {
      selectedPayment.value =
          paymentMethods.first.code;
    }
  }

  // =========================
  // CHANGE DELIVERY
  // =========================

  void selectDelivery(String code) {
    selectedDelivery.value = code;

    _updateShippingFromDelivery();
  }

  void _updateShippingFromDelivery() {
    final selected =
    deliveryOptions.firstWhereOrNull(
          (item) =>
      item.code == selectedDelivery.value,
    );

    if (selected == null) {
      return;
    }

    // Free delivery above Rs. 8000
    if (subtotal.value >= selected.freeAbove) {
      shipping.value = 0;
    } else {
      shipping.value = selected.fee;
    }

    total.value =
        subtotal.value +
            shipping.value -
            discount.value;

    final deliveryText =
    shipping.value == 0
        ? 'Free'
        : 'Rs. ${shipping.value.toStringAsFixed(0)}';

    formattedShipping.value = deliveryText;

    formattedTotal.value =
    'Rs. ${total.value.toStringAsFixed(0)}';
  }

  // =========================
  // PLACE ORDER
  // =========================

  Future<void> placeOrder() async {
    if (isPlacingOrder.value) {
      return;
    }

    if (!_validateForm()) {
      return;
    }

    if (cartItems.isEmpty) {
      Get.snackbar(
        'Cart Empty',
        'Please add products to your cart first.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    try {
      isPlacingOrder.value = true;

      final response = await ApiService.post(
        '/orders',
        body: {
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'address': addressController.text.trim(),
          'city': cityController.text.trim(),
          'postal_code':
          postalCodeController.text.trim(),
          'notes': notesController.text.trim(),
          'delivery': selectedDelivery.value,
          'country': 'Pakistan',
          'is_gift': false,
          'gift_message': '',
        },
      );

      debugPrint(
        'PLACE ORDER RESPONSE: $response',
      );

      if (response['success'] == true) {
        final orderData = response['data']?['order'];

        // SAVE SUCCESSFUL ORDER TO ORDER HISTORY
        if (orderData != null) {
          final historyController = Get.put(
            OrderHistoryController(),
          );

          await historyController.saveOrder(
            Map<String, dynamic>.from(orderData),
          );
        }

        Get.snackbar(
          'Order Placed',
          'Your order has been placed successfully.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );

        Get.toNamed(
          '/order',
          arguments: orderData,
        );
      } else {
        Get.snackbar(
          'Unable to Place Order',
          response['message']?.toString() ??
              'Could not place your order.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      debugPrint(
        'Place Order Error: $e',
      );

      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isPlacingOrder.value = false;
    }
  }

  // =========================
  // FORM VALIDATION
  // =========================

  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      _showValidation(
        'Please enter your full name.',
      );
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      _showValidation(
        'Please enter your email.',
      );
      return false;
    }

    if (phoneController.text.trim().isEmpty) {
      _showValidation(
        'Please enter your phone number.',
      );
      return false;
    }

    if (addressController.text.trim().isEmpty) {
      _showValidation(
        'Please enter your address.',
      );
      return false;
    }

    if (cityController.text.trim().isEmpty) {
      _showValidation(
        'Please enter your city.',
      );
      return false;
    }

    if (postalCodeController.text.trim().isEmpty) {
      _showValidation(
        'Please enter your postal code.',
      );
      return false;
    }

    return true;
  }

  void _showValidation(String message) {
    Get.snackbar(
      'Required Information',
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    notesController.dispose();

    super.onClose();
  }
}