import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/product_model.dart';

import '../../views/splash/splash_screen.dart';
import '../../views/home/home_screen.dart';
import '../../views/product_details/product_details_screen.dart';
import '../../views/cart/cart_screen.dart';
import '../../views/wishlist/wishlist_screen.dart';
import '../../views/checkout/checkout_screen.dart';
import '../../views/order/order_screen.dart';
import '../../views/order/track_order_screen.dart';
import '../../views/order/order_history_screen.dart';
import '../../views/shop/shop_screen.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    // ----------------------------------------------------------
    // SPLASH
    // ----------------------------------------------------------
    GetPage(
      name: '/splash',
      page: () => const SplashScreen(),
    ),

    // ----------------------------------------------------------
    // HOME
    // ----------------------------------------------------------
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
    ),

    // ----------------------------------------------------------
    // PRODUCT DETAILS
    // ----------------------------------------------------------
    GetPage(
      name: AppRoutes.product,
      page: () {
        final arguments = Get.arguments;

        if (arguments is! ProductModel) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Product not found',
              ),
            ),
          );
        }

        return ProductDetailsScreen(
          product: arguments,
        );
      },
    ),

    // ----------------------------------------------------------
    // CART
    // ----------------------------------------------------------
    GetPage(
      name: AppRoutes.cart,
      page: () => CartScreen(),
    ),

    // ----------------------------------------------------------
    // WISHLIST
    // ----------------------------------------------------------
    GetPage(
      name: AppRoutes.wishlist,
      page: () => WishlistScreen(),
    ),

    // ----------------------------------------------------------
    // CHECKOUT
    // ----------------------------------------------------------
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutScreen(),
    ),

    // ----------------------------------------------------------
    // ORDER / PLACE ORDER
    // ----------------------------------------------------------
    GetPage(
      name: AppRoutes.order,
      page: () => const OrderScreen(),
    ),

    // ----------------------------------------------------------
    // TRACK ORDER
    // ----------------------------------------------------------
    GetPage(
      name: AppRoutes.trackOrder,
      page: () => const TrackOrderScreen(),
    ),

    // ----------------------------------------------------------
    // ORDER HISTORY
    // ----------------------------------------------------------
    GetPage(
      name: AppRoutes.orderHistory,
      page: () => const OrderHistoryScreen(),
    ),

    // ----------------------------------------------------------
    // SHOP
    // ----------------------------------------------------------
    GetPage(
      name: AppRoutes.shop,
      page: () => ShopScreen(),
    ),
  ];
}