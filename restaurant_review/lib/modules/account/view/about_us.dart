import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, "account_page.about_us")),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          FlutterI18n.translate(context, "account_page.about_us_content"),
          style: const TextStyle(fontSize: 18.0),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}
