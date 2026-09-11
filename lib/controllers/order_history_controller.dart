import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_model.dart';

class OrderHistoryController extends GetxController {
  final orders = <OrderModel>[].obs;

  static const String _storageKey = 'flashlab_order_history';

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final savedOrders = prefs.getStringList(_storageKey);

      if (savedOrders == null || savedOrders.isEmpty) {
        orders.clear();
        return;
      }

      final loadedOrders = <OrderModel>[];

      for (final orderString in savedOrders) {
        try {
          final json = jsonDecode(orderString);

          if (json is Map<String, dynamic>) {
            loadedOrders.add(
              OrderModel.fromJson(json),
            );
          }
        } catch (e) {
          // Skip invalid saved order
        }
      }

      orders.assignAll(loadedOrders);
    } catch (e) {
      orders.clear();
    }
  }

  Future<void> saveOrder(Map<String, dynamic> orderJson) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final savedOrders =
          prefs.getStringList(_storageKey) ?? <String>[];

      final order = OrderModel.fromJson(orderJson);

      // Avoid saving the same order twice.
      savedOrders.removeWhere((item) {
        try {
          final existing = jsonDecode(item);

          return existing['order_number']?.toString() ==
              order.orderNumber;
        } catch (e) {
          return false;
        }
      });

      // Add newest order at the beginning.
      savedOrders.insert(
        0,
        jsonEncode(orderJson),
      );

      await prefs.setStringList(
        _storageKey,
        savedOrders,
      );

      orders.insert(
        0,
        order,
      );

      // Remove duplicate reactive entries if necessary.
      final seen = <String>{};
      orders.removeWhere(
            (item) => !seen.add(item.orderNumber),
      );
    } catch (e) {
      // Ignore local storage errors.
    }
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_storageKey);

    orders.clear();
  }
}