import '../provider/my_post_provider.dart';

class MyPostRepository {
  final MyPostProvider provider;

  MyPostRepository(this.provider);

  Future<dynamic> getUserPosts(String profileId) async {
    return await provider.getUserPosts(profileId);
  }
}
