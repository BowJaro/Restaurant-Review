import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    controller; // Ensures the controller is initialized
    return Scaffold(
      body: Container(
        color: const Color(0xFFff2f44), // Background color
      ),
    );
  }
}
