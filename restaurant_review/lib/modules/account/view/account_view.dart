import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/global_widgets/image_widgets/avatar_selector.dart';

import '../controller/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        backgroundColor: const Color(0xFFF3F2F7), // Page background
        appBar: AppBar(
          backgroundColor: const Color(0xFFEF4F5F),
          elevation: 0,
          title: const Text(
            'Account',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                // Handle Support action
              },
              icon: const Icon(Icons.support_agent, color: Colors.white),
              label: const Text(
                'Support',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // First Layout
              Container(
                // width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AvatarSelectorWidget(
                      controller: controller.avatarSelectorController,
                      size: 150,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.email,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16), // Space between layouts

              // Second Layout
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _buildButton(context, Icons.person, "Change Profile"),
                    _buildButton(context, Icons.info, "About Us"),
                    _buildButton(context, Icons.policy, "Policy"),
                    _buildButton(context, Icons.feedback, "Feedback"),
                    _buildButton(context, Icons.star, "Rate App"),
                  ],
                ),
              ),

              const SizedBox(height: 16), // Space before Sign Out Button

              // Sign Out Button
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle sign out
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    side: const BorderSide(color: Color(0xFFED5D5D)),
                  ),
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFFED5D5D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Button Builder for Second Layout
  Widget _buildButton(BuildContext context, IconData icon, String title) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: const Color(0xFF919191)),
          title: Text(
            title,
            style: const TextStyle(fontSize: 14),
          ),
          trailing:
              const Icon(Icons.arrow_forward_ios, color: Color(0xFFC0C0C2)),
          onTap: () {
            // Handle button tap
          },
        ),
        const Divider(color: Color(0xFFEEEEF0), height: 1),
      ],
    );
  }
}
