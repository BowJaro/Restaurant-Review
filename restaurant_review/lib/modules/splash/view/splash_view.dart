import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/colors.dart';
import '../controller/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    controller; // Ensures the controller is initialized
    return Scaffold(
      body: Container(
        color: AppColors.white, // Background color
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/logo/tahu-high-resolution-logo.png',
                width: 200, // Adjust size as needed
                height: 200,
                fit: BoxFit.contain, // Keeps image aspect ratio
              ),
              const Text("tesh plash screen")
            ],
          ),
        ),
      ),
    );
  }
}
