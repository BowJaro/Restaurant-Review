import '../model/menu_creation_model.dart';
import '../provider/menu_creation_provider.dart';

class MenuCreationRepository {
  final MenuCreationProvider provider;

  MenuCreationRepository(this.provider);

  Future<dynamic> getMenuItems(int restaurantId) async {
    return await provider.getMenuItems(restaurantId);
  }

  Future<void> upsertMenuItems(
      int restaurantId, List<MenuCreationModel> items) async {
    await provider.upsertMenuItems(restaurantId, items);
  }

  Future<void> removeMenuItems(List<int> ids) async {
    await provider.removeMenuItems(ids);
  }
}
