import 'package:image_picker/image_picker.dart';

class ImageItem {
  final String? url;
  final XFile? file;
  final bool isLocal;

  ImageItem({this.url, this.file}) : isLocal = file != null;

  String get path => file?.path ?? url!;
}
