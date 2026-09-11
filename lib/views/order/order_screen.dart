import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/order_model.dart';
import '../../app/routes/app_routes.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  static const Color background = Color(0xFFF9F7F3);
  static const Color primary = Color(0xFF6B2233);
  static const Color primaryDark = Color(0xFF47131F);
  static const Color gold = Color(0xFFB18A54);
  static const Color text = Color(0xFF2A2224);
  static const Color muted = Color(0xFF6F6669);
  static const Color border = Color(0xFFE8E0D8);
  static const Color white = Colors.white;
  static const Color success = Color(0xFF2F7A51);

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;

    if (arguments == null || arguments is! Map) {
      return _noOrderFound();
    }

    final orderJson = Map<String, dynamic>.from(arguments);
    final order = OrderModel.fromJson(orderJson);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Order Confirmation',
          style: TextStyle(
            color: text,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: text,
            size: 19,
          ),
          onPressed: () => Get.offAllNamed(AppRoutes.home),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSuccessHeader(order),
              const SizedBox(height: 24),
              _buildOrderNumber(order),
              const SizedBox(height: 18),
              _buildItemsSection(order),
              const SizedBox(height: 18),
              _buildCustomerSection(order),
              const SizedBox(height: 18),
              _buildShippingSection(order),
              const SizedBox(height: 18),
              _buildPaymentSection(order),
              const SizedBox(height: 18),
              _buildTotalsSection(order),
              const SizedBox(height: 28),
              _buildActionButtons(),
              const SizedBox(height: 28),
              _buildServiceFeatures(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessHeader(OrderModel order) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 24),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: success.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: success,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'ORDER CONFIRMED',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: primary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your order has been placed successfully.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: text,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Thank you for shopping with FlashLab.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: muted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderNumber(OrderModel order) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: primaryTint(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primary.withOpacity(0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Number',
                  style: TextStyle(
                    color: muted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order.orderNumber,
                  style: const TextStyle(
                    color: primaryDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Text(
            order.placedAtHuman,
            style: const TextStyle(
              color: muted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection(OrderModel order) {
    return _sectionCard(
      title: 'Order Items',
      icon: Icons.shopping_bag_outlined,
      child: Column(
        children: order.items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.image,
                    width: 72,
                    height: 88,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        width: 72,
                        height: 88,
                        color: const Color(0xFFF0E9E0),
                        child: const Icon(
                          Icons.image_outlined,
                          color: muted,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          color: text,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'Quantity: ${item.quantity}',
                        style: const TextStyle(
                          color: muted,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item.formattedPrice,
                        style: const TextStyle(
                          color: gold,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  item.formattedSubtotal,
                  style: const TextStyle(
                    color: primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCustomerSection(OrderModel order) {
    return _sectionCard(
      title: 'Customer Details',
      icon: Icons.person_outline_rounded,
      child: Column(
        children: [
          _detailRow(
            Icons.person_outline,
            'Name',
            order.customer.name,
          ),
          _detailRow(
            Icons.email_outlined,
            'Email',
            order.customer.email,
          ),
          _detailRow(
            Icons.phone_outlined,
            'Phone',
            order.customer.phone,
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildShippingSection(OrderModel order) {
    return _sectionCard(
      title: 'Shipping Details',
      icon: Icons.local_shipping_outlined,
      child: Column(
        children: [
          _detailRow(
            Icons.location_on_outlined,
            'Address',
            order.shipping.address,
          ),
          _detailRow(
            Icons.location_city_outlined,
            'City',
            order.shipping.city,
          ),
          _detailRow(
            Icons.markunread_mailbox_outlined,
            'Postal Code',
            order.shipping.postalCode,
          ),
          _detailRow(
            Icons.public,
            'Country',
            order.shipping.country,
          ),
          _detailRow(
            Icons.local_shipping_outlined,
            'Delivery',
            _formatDelivery(order.shipping.method),
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(OrderModel order) {
    return _sectionCard(
      title: 'Payment',
      icon: Icons.payments_outlined,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFFAF5EC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.payments_outlined,
              color: gold,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatPayment(order.paymentMethod),
                  style: const TextStyle(
                    color: text,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Payment status: ${_formatStatus(order.paymentStatus)}',
                  style: const TextStyle(
                    color: muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _statusBadge(order.status),
        ],
      ),
    );
  }

  Widget _buildTotalsSection(OrderModel order) {
    return _sectionCard(
      title: 'Order Summary',
      icon: Icons.receipt_outlined,
      child: Column(
        children: [
          _summaryRow(
            'Subtotal',
            _formatPrice(order.totals.subtotal),
          ),
          _summaryRow(
            'Shipping',
            order.totals.shipping == 0
                ? 'Free'
                : _formatPrice(order.totals.shipping),
          ),
          _summaryRow(
            'Discount',
            _formatPrice(order.totals.discount),
          ),
          if (order.totals.tax > 0)
            _summaryRow(
              'Tax',
              _formatPrice(order.totals.tax),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              color: border,
              height: 1,
            ),
          ),
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  color: text,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                order.formattedTotal,
                style: const TextStyle(
                  color: primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {
              Get.toNamed(AppRoutes.trackOrder);
            },
            icon: const Icon(
              Icons.local_shipping_outlined,
              size: 19,
            ),
            label: const Text(
              'TRACK ORDER',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () {
              Get.offAllNamed(AppRoutes.home);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: primary,
              side: const BorderSide(
                color: primary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'BACK TO HOME',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () {
              Get.offAllNamed(AppRoutes.home);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryDark,
              side: const BorderSide(
                color: gold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'CONTINUE SHOPPING',
              style: TextStyle(
                color: primaryDark,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceFeatures() {
    return Column(
      children: [
        _featureCard(
          Icons.payments_outlined,
          'Cash on Delivery',
          'Pay when your parcel arrives',
        ),
        const SizedBox(height: 10),
        _featureCard(
          Icons.local_shipping_outlined,
          'Free Delivery',
          'On orders above Rs. 8,000',
        ),
        const SizedBox(height: 10),
        _featureCard(
          Icons.autorenew_rounded,
          'Easy Exchange',
          '7-day hassle-free exchange',
        ),
        const SizedBox(height: 10),
        _featureCard(
          Icons.chat_outlined,
          'Order on WhatsApp',
          '+92 334 232 2324',
        ),
      ],
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: primary,
                size: 20,
              ),
              const SizedBox(width: 9),
              Text(
                title,
                style: const TextStyle(
                  color: text,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _detailRow(
      IconData icon,
      String label,
      String value, {
        bool showDivider = true,
      }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: gold,
                size: 19,
              ),
              const SizedBox(width: 11),
              SizedBox(
                width: 82,
                child: Text(
                  label,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: text,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            color: border,
            height: 1,
          ),
      ],
    );
  }

  Widget _summaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: muted,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: text,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureCard(
      IconData icon,
      String title,
      String subtitle,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFFAF5EC),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              color: gold,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: text,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _formatStatus(status),
        style: const TextStyle(
          color: gold,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _noOrderFound() {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Order Confirmation',
          style: TextStyle(
            color: text,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                color: primary,
                size: 58,
              ),
              const SizedBox(height: 18),
              const Text(
                'No Order Found',
                style: TextStyle(
                  color: text,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'No order information is available.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: muted,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Get.offAllNamed(AppRoutes.home);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: white,
                ),
                child: const Text('BACK TO HOME'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(double value) {
    return 'Rs. ${value.toStringAsFixed(0)}';
  }

  String _formatDelivery(String method) {
    if (method == 'standard') {
      return 'Standard Delivery';
    }

    if (method == 'express') {
      return 'Express Delivery';
    }

    return method.isEmpty
        ? 'Delivery'
        : method;
  }

  String _formatPayment(String method) {
    if (method == 'cod') {
      return 'Cash on Delivery';
    }

    return method.isEmpty
        ? 'Payment'
        : method;
  }

  String _formatStatus(String status) {
    if (status.isEmpty) {
      return 'Pending';
    }

    return status
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) => word.isEmpty
          ? ''
          : '${word[0].toUpperCase()}${word.substring(1)}',
    )
        .join(' ');
  }

  Color primaryTint() {
    return const Color(0xFFF6EEF0);
  }
}