import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/constants/colors.dart';
import 'package:restaurant_review/modules/account/view/change_profile_view.dart';
import 'package:restaurant_review/modules/my_post/view/my_post_view.dart';
import 'package:restaurant_review/routes/routes.dart';

import '../../../constants/singleton_variables.dart';
import '../controller/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingAccountPage.value) {
        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        backgroundColor: const Color(0xFFF3F2F7), // Page background
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          title: Text(FlutterI18n.translate(context, "account_page.account"),
              style: const TextStyle(color: AppColors.white)),
          actions: [
            TextButton.icon(
              onPressed: () {
                // Handle Support action
              },
              icon: const Icon(Icons.support_agent, color: AppColors.white),
              label: Text(
                  FlutterI18n.translate(context, "account_page.support"),
                  style: const TextStyle(color: AppColors.white)),
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
                color: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    controller.avatarUrl == ""
                        ? ClipOval(
                            child: Container(
                              width: 150,
                              height: 150,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ClipOval(
                            child: Image.network(
                              controller.baseImageUrl + controller.avatarUrl,
                              width: 150, // Set the size of the avatar
                              height: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 150,
                                  height: 150,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                            ),
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
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Reviews
                        Column(
                          children: [
                            Text(
                              controller.reviews.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                                FlutterI18n.translate(
                                    context, "account_page.reviews"),
                                style: const TextStyle(fontSize: 14)),
                          ],
                        ),

                        //Followers
                        Column(
                          children: [
                            Text(
                              controller.followers.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                                FlutterI18n.translate(
                                    context, "account_page.followers"),
                                style: const TextStyle(fontSize: 14)),
                          ],
                        ),

                        //Following
                        Column(
                          children: [
                            Text(
                              controller.following.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                                FlutterI18n.translate(
                                    context, "account_page.following"),
                                style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 16), // Space between layouts

              // Second Layout
              Container(
                color: AppColors.white,
                child: Column(
                  children: [
                    _buildButton(
                        context,
                        Icons.reviews,
                        FlutterI18n.translate(
                            context, "account_page.upgrade_to_reviewer"),
                        onTap: () {
                      // Get.to(() => const ChangeProfileView());
                    }),
                    _buildButton(context, Icons.article,
                        FlutterI18n.translate(context, "account_page.my_post"),
                        onTap: () {
                      Get.toNamed(Routes.myPost);
                    }),
                    _buildButton(
                        context,
                        Icons.star,
                        FlutterI18n.translate(
                            context, "account_page.change_profile"), onTap: () {
                      Get.to(() => const ChangeProfileView());
                    }),
                    _buildButton(
                        context,
                        Icons.person,
                        FlutterI18n.translate(
                            context, "account_page.about_us")),
                    _buildButton(context, Icons.info,
                        FlutterI18n.translate(context, "account_page.policy")),
                    _buildButton(
                        context,
                        Icons.policy,
                        FlutterI18n.translate(
                            context, "account_page.feedback")),
                    _buildButton(
                        context,
                        Icons.feedback,
                        FlutterI18n.translate(
                            context, "account_page.rate_app")),
                  ],
                ),
              ),

              const SizedBox(height: 16), // Space before Sign Out Button

              // Sign Out Button
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  // Handle sign out
                  onPressed: () async {
                    await supabase.auth.signOut();
                    Get.offAllNamed(Routes.splash);
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    FlutterI18n.translate(context, "account_page.sign_out"),
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textRed,
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

  Widget _buildButton(
    BuildContext context,
    IconData icon,
    String title, {
    VoidCallback? onTap, // Make it nullable
  }) {
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
          onTap:
              onTap ?? () {}, // Provide default empty action if onTap is null
        ),
        const Divider(color: Color(0xFFEEEEF0), height: 1),
      ],
    );
  }
}
