import 'package:restaurant_review/modules/brand_detail/model/brand_detail_model.dart';
import 'package:restaurant_review/modules/brand_detail/provider/brand_detail_provider.dart';

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
