import '../provider/following_provider.dart';

class FollowingRepository {
  final FollowingProvider provider;

  FollowingRepository(this.provider);

  Future<dynamic> getFollowing(String profileId) async {
    return await provider.getFollowing(profileId);
  }

  Future<void> removeFollowing(
      {required String profileId,
      required String source,
      required String type}) async {
    return await provider.removeFollowing(profileId, source, type);
  }
}
