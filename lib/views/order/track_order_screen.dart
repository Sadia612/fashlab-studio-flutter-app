import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../controllers/track_order_controller.dart';
import '../../models/order_model.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  static const Color cream = Color(0xFFF9F7F3);
  static const Color maroon = Color(0xFF6B2233);
  static const Color darkMaroon = Color(0xFF47131F);
  static const Color gold = Color(0xFFB18A54);
  static const Color ink = Color(0xFF1A1416);
  static const Color textLight = Color(0xFF6F6669);
  static const Color border = Color(0xFFE8E0D8);
  static const Color success = Color(0xFF2F7A51);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TrackOrderController());

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ink,
            size: 19,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Track Order',
          style: TextStyle(
            color: ink,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(
              () => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),

                _buildInputCard(controller),

                if (controller.errorMessage.value.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildError(controller.errorMessage.value),
                ],

                if (controller.order.value != null) ...[
                  const SizedBox(height: 24),
                  _buildOrderResult(controller.order.value!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: maroon.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.local_shipping_outlined,
            color: maroon,
            size: 26,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Where is your order?',
          style: TextStyle(
            color: ink,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'Enter your order number and email or phone number to view your order status.',
          style: TextStyle(
            color: textLight,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildInputCard(TrackOrderController controller) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          _buildTextField(
            controller: controller.orderNumberController,
            label: 'Order Number',
            hint: 'e.g. TC-20260910-91C9FD',
            icon: Icons.receipt_long_outlined,
          ),
          const SizedBox(height: 15),
          _buildTextField(
            controller: controller.contactController,
            label: 'Email or Phone',
            hint: 'Enter email or phone number',
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.trackOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: maroon,
                disabledBackgroundColor: maroon.withValues(alpha: 0.5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: Colors.white,
                ),
              )
                  : const Text(
                'TRACK ORDER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: ink,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: maroon,
          size: 21,
        ),
        labelStyle: const TextStyle(
          color: textLight,
          fontSize: 13,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFFAAA1A4),
          fontSize: 13,
        ),
        filled: true,
        fillColor: cream,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: maroon,
            width: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3F3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE7B8B8),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFB33A3A),
            size: 21,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFF8F2F2F),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderResult(OrderModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOrderSummary(order),
        const SizedBox(height: 16),
        _buildTimeline(order),
        const SizedBox(height: 16),
        _buildCustomerDetails(order),
        const SizedBox(height: 16),
        _buildShippingDetails(order),
        const SizedBox(height: 16),
        _buildItems(order),
        const SizedBox(height: 16),
        _buildTotal(order),
        const SizedBox(height: 24),
        _buildBackHomeButton(),
      ],
    );
  }

  Widget _buildOrderSummary(OrderModel order) {
    return _sectionCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: maroon.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  color: maroon,
                  size: 25,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Found',
                      style: TextStyle(
                        color: ink,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.orderNumber,
                      style: const TextStyle(
                        color: maroon,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cream,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Current Status',
                  style: TextStyle(
                    color: textLight,
                    fontSize: 13,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: maroon.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _formatStatus(order.status),
                    style: const TextStyle(
                      color: maroon,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Placed',
                style: TextStyle(
                  color: textLight,
                  fontSize: 13,
                ),
              ),
              Text(
                order.placedAtHuman,
                style: const TextStyle(
                  color: ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(OrderModel order) {
    return _sectionCard(
      title: 'Order Status',
      icon: Icons.timeline_rounded,
      child: Column(
        children: List.generate(
          order.flow.length,
              (index) {
            final status = order.flow[index];
            final currentIndex = order.flow.indexOf(order.status);
            final isCompleted = currentIndex >= 0 && index <= currentIndex;
            final isCurrent = status == order.status;
            final isLast = index == order.flow.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? maroon
                            : const Color(0xFFF1ECE8),
                        border: Border.all(
                          color: isCompleted ? maroon : border,
                        ),
                      ),
                      child: Icon(
                        isCompleted
                            ? Icons.check_rounded
                            : Icons.circle_outlined,
                        size: 17,
                        color: isCompleted
                            ? Colors.white
                            : const Color(0xFFB5AAAD),
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 1.5,
                        height: 35,
                        color: isCompleted ? maroon : border,
                      ),
                  ],
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _formatStatus(status),
                            style: TextStyle(
                              color: isCurrent ? maroon : ink,
                              fontSize: 13,
                              fontWeight:
                              isCurrent ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                        if (isCurrent)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: gold.withValues(alpha: 0.13),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'CURRENT',
                              style: TextStyle(
                                color: gold,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.7,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCustomerDetails(OrderModel order) {
    return _sectionCard(
      title: 'Customer Details',
      icon: Icons.person_outline_rounded,
      child: Column(
        children: [
          _detailRow(
            Icons.person_outline,
            'Customer Name',
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
          ),
        ],
      ),
    );
  }

  Widget _buildShippingDetails(OrderModel order) {
    return _sectionCard(
      title: 'Shipping Details',
      icon: Icons.location_on_outlined,
      child: Column(
        children: [
          _detailRow(
            Icons.home_outlined,
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
            Icons.local_shipping_outlined,
            'Delivery',
            _formatStatus(order.shipping.method),
          ),
        ],
      ),
    );
  }

  Widget _buildItems(OrderModel order) {
    return _sectionCard(
      title: 'Order Items',
      icon: Icons.shopping_bag_outlined,
      child: Column(
        children: order.items.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cream,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.network(
                    item.image,
                    width: 68,
                    height: 78,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        width: 68,
                        height: 78,
                        color: const Color(0xFFEDE6DF),
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: textLight,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: ink,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'Qty: ${item.quantity}',
                        style: const TextStyle(
                          color: textLight,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item.formattedSubtotal,
                        style: const TextStyle(
                          color: maroon,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTotal(OrderModel order) {
    return _sectionCard(
      child: Column(
        children: [
          _totalRow(
            'Subtotal',
            'Rs. ${order.totals.subtotal.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 10),
          _totalRow(
            'Shipping',
            'Rs. ${order.totals.shipping.toStringAsFixed(0)}',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: Divider(
              color: border,
              height: 1,
            ),
          ),
          _totalRow(
            'Total',
            'Rs. ${order.totals.total.toStringAsFixed(0)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBackHomeButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () => Get.offAllNamed(AppRoutes.home),
        style: OutlinedButton.styleFrom(
          foregroundColor: maroon,
          side: const BorderSide(
            color: maroon,
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'BACK TO HOME',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({
    String? title,
    IconData? icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    color: maroon,
                    size: 20,
                  ),
                if (icon != null) const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
          child,
        ],
      ),
    );
  }

  Widget _detailRow(
      IconData icon,
      String label,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: gold,
            size: 18,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                color: textLight,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: const TextStyle(
                color: ink,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(
      String label,
      String value, {
        bool isTotal = false,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? ink : textLight,
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? maroon : ink,
            fontSize: isTotal ? 16 : 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String _formatStatus(String status) {
    if (status.isEmpty) return 'Unknown';

    return status
        .split('_')
        .map(
          (word) => word.isEmpty
          ? word
          : '${word[0].toUpperCase()}${word.substring(1)}',
    )
        .join(' ');
  }
}