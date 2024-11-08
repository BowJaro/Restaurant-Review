import '../model/brand_detail_model.dart';
import '../provider/brand_detail_provider.dart';

class BrandDetailRepository {
  final BrandDetailProvider provider;

  BrandDetailRepository(this.provider);

  Future<bool> upsertBrand(BrandDetailModel brandDetailModel) async {
    return await provider.upsertBrand(brandDetailModel);
  }

  Future<dynamic> fetchBrand(int id) async {
    return await provider.fetchBrand(id);
  }
}