import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_review/routes/routes.dart';
import 'package:restaurant_review/services/supabase.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home'),
            TextButton(
                onPressed: () async {
                  await supabase.auth.signOut();
                  Get.offAllNamed(Routes.splash);
                },
                child: Text("Sign out"))
          ],
        ),
      ),
    );
  }
}
