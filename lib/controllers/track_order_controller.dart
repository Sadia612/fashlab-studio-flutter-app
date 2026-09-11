import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/order_model.dart';
import '../services/api_service.dart';

class TrackOrderController extends GetxController {
  final orderNumberController = TextEditingController();
  final contactController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final order = Rxn<OrderModel>();

  Future<void> trackOrder() async {
    final orderNumber = orderNumberController.text.trim();
    final contact = contactController.text.trim();

    if (orderNumber.isEmpty) {
      errorMessage.value = 'Please enter your order number.';
      return;
    }

    if (contact.isEmpty) {
      errorMessage.value = 'Please enter your email or phone number.';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await ApiService.post(
        '/orders/track',
        body: {
          'order_number': orderNumber,
          'contact': contact,
        },
      );

      debugPrint('TRACK ORDER RESPONSE: $response');

      if (response['success'] == true &&
          response['data']?['order'] != null) {
        final orderJson =
        Map<String, dynamic>.from(response['data']['order']);

        order.value = OrderModel.fromJson(orderJson);
      } else {
        errorMessage.value =
            response['message']?.toString() ??
                'Order could not be found.';
      }
    } catch (e) {
      debugPrint('TRACK ORDER ERROR: $e');
      errorMessage.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void clearResult() {
    order.value = null;
    errorMessage.value = '';
  }

  @override
  void onClose() {
    orderNumberController.dispose();
    contactController.dispose();
    super.onClose();
  }
}