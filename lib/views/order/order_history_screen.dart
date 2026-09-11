import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/order_history_controller.dart';
import '../../models/order_model.dart';
import '../../app/routes/app_routes.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  static const Color primary = Color(0xFF6B2233);
  static const Color primaryDark = Color(0xFF47131F);
  static const Color gold = Color(0xFFB18A54);
  static const Color background = Color(0xFFF9F7F3);
  static const Color text = Color(0xFF1A1416);
  static const Color textLight = Color(0xFF6F6669);
  static const Color border = Color(0xFFE8E0D8);
  static const Color success = Color(0xFF2F7A51);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      OrderHistoryController(),
    );

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 19,
            color: primaryDark,
          ),
        ),
        title: const Text(
          'MY ORDERS',
          style: TextStyle(
            color: primaryDark,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.orders.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          color: primary,
          onRefresh: controller.loadOrders,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              16,
              10,
              16,
              30,
            ),
            children: [
              const Text(
                'ORDER HISTORY',
                style: TextStyle(
                  color: text,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${controller.orders.length} order${controller.orders.length == 1 ? '' : 's'} placed',
                style: const TextStyle(
                  color: textLight,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              ...controller.orders.map(
                    (order) => _buildOrderCard(
                  order,
                  controller,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOrderCard(
      OrderModel order,
      OrderHistoryController controller,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: border,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ORDER NUMBER',
                        style: TextStyle(
                          color: textLight,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        order.orderNumber,
                        style: const TextStyle(
                          color: primaryDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(
                  order.status,
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Divider(
              color: border,
              height: 1,
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _infoItem(
                    Icons.calendar_today_outlined,
                    'DATE',
                    order.placedAtHuman.isNotEmpty
                        ? order.placedAtHuman
                        : 'Recently',
                  ),
                ),
                Expanded(
                  child: _infoItem(
                    Icons.shopping_bag_outlined,
                    'ITEMS',
                    '${order.items.length}',
                  ),
                ),
                Expanded(
                  child: _infoItem(
                    Icons.payments_outlined,
                    'TOTAL',
                    order.formattedTotal.isNotEmpty
                        ? order.formattedTotal
                        : 'Rs. ${order.total.toStringAsFixed(0)}',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (order.items.isNotEmpty)
              _buildItemsSummary(order),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.toNamed(
                        AppRoutes.order,
                        arguments:
                        _orderToJson(order),
                      );
                    },
                    style:
                    OutlinedButton.styleFrom(
                      foregroundColor: primary,
                      side: const BorderSide(
                        color: primary,
                      ),
                      minimumSize:
                      const Size(
                        double.infinity,
                        46,
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(7),
                      ),
                    ),
                    child: const Text(
                      'VIEW DETAILS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                        FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(
                        AppRoutes.trackOrder,
                      );
                    },
                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor:
                      Colors.white,
                      elevation: 0,
                      minimumSize:
                      const Size(
                        double.infinity,
                        46,
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(7),
                      ),
                    ),
                    child: const Text(
                      'TRACK ORDER',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                        FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(
      IconData icon,
      String label,
      String value,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 17,
          color: gold,
        ),
        const SizedBox(height: 7),
        Text(
          label,
          style: const TextStyle(
            color: textLight,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: text,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsSummary(
      OrderModel order,
      ) {
    final visibleItems =
    order.items.take(2).toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius:
        BorderRadius.circular(8),
        border: Border.all(
          color: border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'ITEMS',
            style: TextStyle(
              color: textLight,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),

          ...visibleItems.map(
                (item) => Padding(
              padding:
              const EdgeInsets.only(
                bottom: 5,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: text,
                        fontSize: 12,
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    'x${item.quantity}',
                    style: const TextStyle(
                      color: textLight,
                      fontSize: 11,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (order.items.length > 2)
            Text(
              '+ ${order.items.length - 2} more item${order.items.length - 2 == 1 ? '' : 's'}',
              style: const TextStyle(
                color: primary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(
      String status,
      ) {
    final formattedStatus = status
        .replaceAll('_', ' ')
        .toUpperCase();

    final isDelivered =
        status.toLowerCase() == 'delivered';

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isDelivered
            ? success.withValues(alpha: 0.10)
            : const Color(0xFFF6EEF0),
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Text(
        formattedStatus,
        style: TextStyle(
          color:
          isDelivered ? success : primary,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 35,
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color:
                const Color(0xFFF6EEF0),
                borderRadius:
                BorderRadius.circular(41),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 38,
                color: primary,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'NO ORDERS YET',
              style: TextStyle(
                color: primaryDark,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your successfully placed orders will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textLight,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 190,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Get.offAllNamed(
                    AppRoutes.home,
                  );
                },
                style:
                ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor:
                  Colors.white,
                  elevation: 0,
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(7),
                  ),
                ),
                child: const Text(
                  'START SHOPPING',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                    FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _orderToJson(
      OrderModel order,
      ) {
    return {
      'id': order.id,
      'order_number': order.orderNumber,
      'status': order.status,
      'payment_status':
      order.paymentStatus,
      'payment_method':
      order.paymentMethod,
      'total': order.total,
      'formatted_total':
      order.formattedTotal,
      'placed_at_human':
      order.placedAtHuman,

      'customer': {
        'name': order.customer.name,
        'email': order.customer.email,
        'phone': order.customer.phone,
      },

      'shipping': {
        'address':
        order.shipping.address,
        'city': order.shipping.city,
        'postal_code':
        order.shipping.postalCode,
        'country':
        order.shipping.country,
        'method':
        order.shipping.method,
      },

      'totals': {
        'subtotal':
        order.totals.subtotal,
        'shipping':
        order.totals.shipping,
        'discount':
        order.totals.discount,
        'tax':
        order.totals.tax,
        'total':
        order.totals.total,
      },

      'items': order.items.map(
            (item) {
          return {
            'product_id':
            item.productId,
            'name': item.name,
            'quantity':
            item.quantity,
            'price': item.price,
            'subtotal':
            item.subtotal,
            'formatted_price':
            item.formattedPrice,
            'formatted_subtotal':
            item.formattedSubtotal,
            'image': item.image,
          };
        },
      ).toList(),

      'timeline': order.timeline.map(
            (item) {
          return {
            'status': item.status,
            'label': item.label,
            'note': item.note,
            'human': item.human,
          };
        },
      ).toList(),

      'flow': order.flow,
      'can_cancel':
      order.canCancel,
    };
  }
}