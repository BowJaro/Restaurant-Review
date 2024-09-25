import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullImageView extends StatelessWidget {
  final String url;

  const FullImageView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: 'imageHero_${url.hashCode}',
          child: CachedNetworkImage(
            memCacheHeight: 600,
            memCacheWidth: 600,
            imageUrl: url,
            fit: BoxFit.contain,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
