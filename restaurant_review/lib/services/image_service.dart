import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_review/services/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      // Add a timestamp to the file name
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = path.split('/').last; // Extract the original file name
      final directory =
          path.substring(0, path.lastIndexOf('/')); // Extract the directory
      final newPath =
          '$directory/${timestamp}_$fileName'; // Append timestamp to the file name
      final response =
          await supabase.storage.from(bucketName).upload(newPath, file);

      if (response.isEmpty) {
        print('=========Failed to upload image=========');
        return ""; // Return an empty string if the upload fails
      }

      return response; // Return the path if upload is successful
    } on StorageException catch (e) {
      if (e.statusCode == 409.toString() &&
          e.message.contains('The resource already exists')) {
        return "$bucketName/$path";
      } else {
        print('=========Error uploading image: $e=========');
        return ""; // Return an empty string for other errors
      }
    } catch (e) {
      print('=========Unexpected error uploading image: $e=========');
      return ""; // Handle any other types of exceptions
    }
  }
}
