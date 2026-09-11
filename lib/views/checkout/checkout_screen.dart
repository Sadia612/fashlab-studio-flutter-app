import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_theme.dart';
import '../../controllers/checkout_controller.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckoutController());

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.ink,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppTheme.primary,
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return _errorState(controller);
        }

        if (controller.cartItems.isEmpty) {
          return _emptyState();
        }

        return _checkoutContent(controller);
      }),
    );
  }

  // =========================================================
  // CHECKOUT CONTENT
  // =========================================================

  Widget _checkoutContent(CheckoutController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            'Delivery Information',
            'Enter your details for delivery',
          ),

          const SizedBox(height: 16),

          _formCard(controller),

          const SizedBox(height: 24),

          _sectionTitle(
            'Delivery Method',
            'Choose your preferred delivery option',
          ),

          const SizedBox(height: 12),

          _deliverySection(controller),

          const SizedBox(height: 24),

          _sectionTitle(
            'Payment Method',
            'Available payment options',
          ),

          const SizedBox(height: 12),

          _paymentSection(controller),

          const SizedBox(height: 24),

          _couponSection(),

          const SizedBox(height: 24),

          _serviceFeatures(),

          const SizedBox(height: 24),

          _orderSummary(controller),

          const SizedBox(height: 24),

          _whatsappSection(),

          const SizedBox(height: 24),

          _placeOrderButton(controller),

          const SizedBox(height: 12),

          Center(
            child: Text(
              'By placing your order, you agree to our terms and policies.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.textMuted,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SECTION TITLE
  // =========================================================

  Widget _sectionTitle(
      String title,
      String subtitle,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppTheme.ink,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textLight,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // FORM CARD
  // =========================================================

  Widget _formCard(CheckoutController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: Column(
        children: [
          _textField(
            controller: controller.nameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            icon: Icons.person_outline,
          ),

          const SizedBox(height: 14),

          _textField(
            controller: controller.emailController,
            label: 'Email Address',
            hint: 'Enter your email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 14),

          _textField(
            controller: controller.phoneController,
            label: 'Phone Number',
            hint: '03XX XXXXXXX',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),

          const SizedBox(height: 14),

          _textField(
            controller: controller.addressController,
            label: 'Delivery Address',
            hint: 'House, street, area',
            icon: Icons.location_on_outlined,
            maxLines: 2,
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _textField(
                  controller: controller.cityController,
                  label: 'City',
                  hint: 'Your city',
                  icon: Icons.location_city_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _textField(
                  controller: controller.postalCodeController,
                  label: 'Postal Code',
                  hint: 'Postal code',
                  icon: Icons.markunread_mailbox_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _textField(
            controller: controller.notesController,
            label: 'Order Notes',
            hint: 'Any special instructions? (Optional)',
            icon: Icons.notes_outlined,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  // =========================================================
  // TEXT FIELD
  // =========================================================

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(
        color: AppTheme.text,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          size: 20,
          color: AppTheme.textLight,
        ),
      ),
    );
  }

  // =========================================================
  // DELIVERY SECTION
  // =========================================================

  Widget _deliverySection(
      CheckoutController controller,
      ) {
    return Obx(() {
      return Column(
        children: controller.deliveryOptions.map((option) {
          final selected =
              controller.selectedDelivery.value == option.code;

          final isFree =
              controller.subtotal.value >= option.freeAbove;

          final feeText = isFree
              ? 'FREE'
              : option.formattedFee;

          return GestureDetector(
            onTap: () {
              controller.selectDelivery(option.code);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primaryTint
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? AppTheme.primary
                      : AppTheme.border,
                  width: selected ? 1.4 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected
                            ? AppTheme.primary
                            : AppTheme.borderStrong,
                        width: 2,
                      ),
                    ),
                    child: selected
                        ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primary,
                        ),
                      ),
                    )
                        : null,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                option.name,
                                style: const TextStyle(
                                  color: AppTheme.text,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              feeText,
                              style: TextStyle(
                                color: isFree
                                    ? AppTheme.success
                                    : AppTheme.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        Text(
                          option.description,
                          style: const TextStyle(
                            color: AppTheme.textLight,
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          option.estimatedDays,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  // =========================================================
  // PAYMENT SECTION
  // =========================================================

  Widget _paymentSection(
      CheckoutController controller,
      ) {
    return Obx(() {
      return Column(
        children: controller.paymentMethods.map((payment) {
          final selected =
              controller.selectedPayment.value == payment.code;

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? AppTheme.primary
                    : AppTheme.border,
                width: selected ? 1.4 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryTint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.payments_outlined,
                    color: AppTheme.primary,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment.name,
                        style: const TextStyle(
                          color: AppTheme.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Pay when your parcel arrives',
                        style: TextStyle(
                          color: AppTheme.textLight,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                Radio<String>(
                  value: payment.code,
                  groupValue:
                  controller.selectedPayment.value,
                  activeColor: AppTheme.primary,
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedPayment.value = value;
                    }
                  },
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }

  // =========================================================
  // COUPON
  // =========================================================

  Widget _couponSection() {
    final couponController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppTheme.goldTint,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.local_offer_outlined,
                  color: AppTheme.gold,
                  size: 20,
                ),
              ),

              const SizedBox(width: 10),

              const Text(
                'HAVE A COUPON?',
                style: TextStyle(
                  color: AppTheme.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: couponController,
                  textCapitalization:
                  TextCapitalization.characters,
                  style: const TextStyle(
                    color: AppTheme.text,
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Enter coupon code',
                    prefixIcon: Icon(
                      Icons.confirmation_number_outlined,
                      color: AppTheme.textLight,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              SizedBox(
                width: 90,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (couponController.text
                        .trim()
                        .isEmpty) {
                      Get.snackbar(
                        'Coupon Code',
                        'Please enter a coupon code.',
                        snackPosition:
                        SnackPosition.BOTTOM,
                        margin:
                        const EdgeInsets.all(16),
                        backgroundColor: AppTheme.ink,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    Get.snackbar(
                      'Coupon',
                      'This coupon is not available.',
                      snackPosition:
                      SnackPosition.BOTTOM,
                      margin:
                      const EdgeInsets.all(16),
                      backgroundColor: AppTheme.ink,
                      colorText: Colors.white,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize:
                    const Size(90, 52),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    'APPLY',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SERVICE FEATURES
  // =========================================================

  Widget _serviceFeatures() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: Column(
        children: [
          _featureRow(
            icon: Icons.payments_outlined,
            title: 'Cash on Delivery',
            subtitle: 'Pay when your parcel arrives',
          ),

          const SizedBox(height: 18),

          _featureRow(
            icon: Icons.local_shipping_outlined,
            title: 'Free Delivery',
            subtitle: 'On orders above Rs. 8,000',
          ),

          const SizedBox(height: 18),

          _featureRow(
            icon: Icons.sync_outlined,
            title: 'Easy Exchange',
            subtitle: '7-day hassle-free exchange',
          ),

          const SizedBox(height: 18),

          _featureRow(
            icon: Icons.chat_outlined,
            title: 'Order on WhatsApp',
            subtitle: '+92 334 232 2324',
          ),
        ],
      ),
    );
  }

  Widget _featureRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppTheme.primaryTint,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppTheme.primary,
            size: 21,
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
                  color: AppTheme.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================
  // ORDER SUMMARY
  // =========================================================

  Widget _orderSummary(
      CheckoutController controller,
      ) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppTheme.border,
          ),
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(
                color: AppTheme.ink,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            ...controller.cartItems.map(
                  (item) => Padding(
                padding:
                const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(8),
                      child: Image.network(
                        item.image,
                        width: 58,
                        height: 68,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) {
                          return Container(
                            width: 58,
                            height: 68,
                            color: AppTheme.creamDark,
                            child: const Icon(
                              Icons.image_outlined,
                              color:
                              AppTheme.textMuted,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            maxLines: 2,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppTheme.text,
                              fontSize: 13,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Qty: ${item.quantity}',
                            style: const TextStyle(
                              color:
                              AppTheme.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      item.formattedLineTotal,
                      style: const TextStyle(
                        color: AppTheme.text,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(
              height: 24,
              color: AppTheme.border,
            ),

            _summaryRow(
              'Subtotal',
              controller.formattedSubtotal.value.isEmpty
                  ? 'Rs. ${controller.subtotal.value.toStringAsFixed(0)}'
                  : controller.formattedSubtotal.value,
            ),

            const SizedBox(height: 10),

            _summaryRow(
              'Shipping',
              controller.formattedShipping.value.isEmpty
                  ? (controller.shipping.value == 0
                  ? 'Free'
                  : 'Rs. ${controller.shipping.value.toStringAsFixed(0)}')
                  : controller.formattedShipping.value,
              valueColor: controller.shipping.value == 0
                  ? AppTheme.success
                  : AppTheme.text,
            ),

            const SizedBox(height: 10),

            _summaryRow(
              'Discount',
              controller.formattedDiscount.value.isEmpty
                  ? 'Rs. ${controller.discount.value.toStringAsFixed(0)}'
                  : controller.formattedDiscount.value,
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Divider(
                color: AppTheme.borderStrong,
              ),
            ),

            _summaryRow(
              'Total',
              controller.formattedTotal.value.isEmpty
                  ? 'Rs. ${controller.total.value.toStringAsFixed(0)}'
                  : controller.formattedTotal.value,
              isTotal: true,
            ),
          ],
        ),
      );
    });
  }

  Widget _summaryRow(
      String title,
      String value, {
        Color? valueColor,
        bool isTotal = false,
      }) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isTotal
                ? AppTheme.ink
                : AppTheme.textLight,
            fontSize: isTotal ? 15 : 13,
            fontWeight:
            isTotal ? FontWeight.w700 : FontWeight.w500,
          ),
        ),

        Text(
          value,
          style: TextStyle(
            color: valueColor ??
                (isTotal
                    ? AppTheme.primary
                    : AppTheme.text),
            fontSize: isTotal ? 17 : 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // WHATSAPP SECTION
  // =========================================================

  Widget _whatsappSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.primaryTint,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.border,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppTheme.whatsapp,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat,
              color: Colors.white,
              size: 25,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Order on WhatsApp',
            style: TextStyle(
              color: AppTheme.ink,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            '+92 334 232 2324',
            style: TextStyle(
              color: AppTheme.textLight,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _openWhatsApp,
              icon: const Icon(
                Icons.chat,
                size: 19,
              ),
              label: const Text(
                'CHAT ON WHATSAPP',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.whatsapp,
                foregroundColor: Colors.white,
                minimumSize:
                const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // WHATSAPP ACTION
  // =========================================================

  Future<void> _openWhatsApp() async {
    final Uri url = Uri.parse(
      'https://wa.me/923342322324',
    );

    try {
      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        Get.snackbar(
          'WhatsApp',
          'Could not open WhatsApp.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      Get.snackbar(
        'WhatsApp',
        'Could not open WhatsApp.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  // =========================================================
  // PLACE ORDER BUTTON
  // =========================================================

  Widget _placeOrderButton(
      CheckoutController controller,
      ) {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: controller.isPlacingOrder.value
              ? null
              : controller.placeOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor:
            AppTheme.primaryLight,
            disabledForegroundColor: Colors.white,
            minimumSize:
            const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(8),
            ),
          ),
          child: controller.isPlacingOrder.value
              ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Text(
            'PLACE ORDER',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
      );
    });
  }

  // =========================================================
  // EMPTY STATE
  // =========================================================

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppTheme.primaryTint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 34,
                color: AppTheme.primary,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Your Cart Is Empty',
              style: TextStyle(
                color: AppTheme.ink,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Add some products to your bag before checking out.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 13,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: 190,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Get.offAllNamed(
                    AppRoutes.home,
                  );
                },
                child: const Text(
                  'CONTINUE SHOPPING',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // ERROR STATE
  // =========================================================

  Widget _errorState(
      CheckoutController controller,
      ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppTheme.primaryTint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 32,
                color: AppTheme.primary,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Unable to Load Checkout',
              style: TextStyle(
                color: AppTheme.ink,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textLight,
                fontSize: 13,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: 150,
              height: 48,
              child: ElevatedButton(
                onPressed: controller.fetchCheckout,
                child: const Text(
                  'TRY AGAIN',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}