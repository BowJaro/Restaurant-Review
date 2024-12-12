import '../provider/menu_view_provider.dart';

class MenuViewRepository {
  final MenuViewProvider provider;

  MenuViewRepository(this.provider);

  Future<dynamic> getMenuItems(int restaurantId) async {
    return await provider.getMenuItems(restaurantId);
  }
}
