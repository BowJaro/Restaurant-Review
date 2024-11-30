import '../provider/brand_page_provider.dart';

class BrandPageRepository {
  final BrandPageProvider provider;

  BrandPageRepository(this.provider);

  Future<dynamic> getBrandPage(int brandId, String profileId) async {
    return await provider.getBrandPage(brandId, profileId);
  }

  Future<void> toggleFollowing(
      {required int source,
      required String type,
      required String profileId}) async {
    return await provider.toggleFollowing(source, type, profileId);
  }
}
