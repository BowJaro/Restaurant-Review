import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_review/services/supabase.dart';

class ImageService extends GetxService {
  Future<Uint8List?> fetchImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('=========Failed to load image: ${response.statusCode}=========');
        return null;
      }
    } catch (e) {
      print('=========Error fetching image: $e=========');
      return null;
    }
  }

  Future<String> uploadImage(
      XFile image, String bucketName, String path) async {
    try {
      final file = File(image.path); // Convert XFile to File
      final response =
          await supabase.storage.from(bucketName).upload(path, file);
      if (response.isEmpty) {
        print('=========Failed to upload image=========');
      }
      return response;
    } catch (e) {
      print('=========Error uploading image: $e=========');
      return "";
    }
  }
}
