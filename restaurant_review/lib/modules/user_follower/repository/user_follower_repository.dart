import '../provider/user_follower_provider.dart';

class UserFollowerRepository {
  final UserFollowerProvider provider;

  UserFollowerRepository(this.provider);

  Future<dynamic> getFollowers(String profileId) async {
    return await provider.getFollowers(profileId);
  }

  Future<void> removeFollowers(
      {required String profileId,
      required String source,
      required String type}) async {
    return await provider.removeFollowers(profileId, source, type);
  }
}
