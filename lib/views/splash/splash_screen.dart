import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(
      const Duration(seconds: 3),
          () {
        Get.offAllNamed(AppRoutes.home);
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8C08A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // FASHLAB LOGO
            Container(
              width: 250,
              height: 170,
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/logo-wordmark.png',
                width: 240,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 30),

            Container(
              width: 45,
              height: 1,
              color: const Color(0xFF3A342B),
            ),

            const SizedBox(height: 22),

            const Text(
              'FASHLAB STUDIO',
              style: TextStyle(
                color: Color(0xFF2C2925),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 3.5,
              ),
            ),

            const SizedBox(height: 9),

            const Text(
              'ELEVATED FASHION',
              style: TextStyle(
                color: Color(0xFF5E5547),
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}