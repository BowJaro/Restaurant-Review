import 'package:restaurant_review/modules/post_detail/model/post_with_rate_upsert_model.dart';

import '../model/post_upsert_model.dart';
import '../provider/post_detail_provider.dart';

class PostDetailRepository {
  final PostDetailProvider provider;

  PostDetailRepository(this.provider);

  Future<dynamic> fetchDataForNewPost() async {
    return await provider.fetchDataForNewPost();
  }

  Future<dynamic> fetchDataForPostEdit(int id) async {
    return await provider.fetchDataForPostEdit(id);
  }

  Future<bool> upsertPost(PostUpsertModel postUpsertModel) async {
    return await provider.upsertPost(postUpsertModel);
  }

  Future<bool> upsertPostWithRate(
      PostWithRateUpsertModel postWithRateUpsertModel) async {
    return await provider.upsertPostWithRate(postWithRateUpsertModel);
  }
}
