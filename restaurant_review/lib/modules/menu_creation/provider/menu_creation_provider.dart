import 'package:image_picker/image_picker.dart';
import 'package:restaurant_review/global_classes/image_item.dart';
import 'package:restaurant_review/services/image_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/menu_creation_model.dart';

class MenuCreationProvider {
  final SupabaseClient supabase;
  final ImageService imageService = ImageService();

  MenuCreationProvider(this.supabase);

  /// Get menu items for the given restaurant id
  Future<dynamic> getMenuItems(int restaurantId) async {
    final response = await supabase
        .rpc('get_menu_items', params: {'p_restaurant_id': restaurantId});
    return response;
  }

  /// Call the stored procedure to upsert menu items
  Future<void> upsertMenuItems(
      int restaurantId, List<MenuCreationModel> menuItems) async {
    final futures = <Future>[];
    for (final item in menuItems) {
      if (item.image.value.file is XFile) {
        futures.add(
          imageService
              .uploadImage(
            item.image.value.file!,
            'images',
            'menus/${DateTime.now().millisecondsSinceEpoch}',
          )
              .then((imageUrl) {
            item.image.value = ImageItem(url: imageUrl);
          }),
        );
      }
    }
    await Future.wait(futures);

    final items = menuItems
        .map((item) => {
              'id': item.id,
              'name': item.name.value,
              'description': item.description.value,
              'price': item.price.value.toString(),
              'image_url': item.image.value.url,
            })
        .toList();

    await supabase.rpc('upsert_menu_items', params: {
      'p_restaurant_id': restaurantId,
      'p_menu_items': items,
    });
  }

  /// Call the stored procedure to remove menu items
  Future<void> removeMenuItems(List<int> ids) async {
    await Future.wait(
        ids.map((id) => supabase.from('menu_item').delete().eq('id', id)));
  }
}
