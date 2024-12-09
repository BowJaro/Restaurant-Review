import '../provider/user_provider.dart';

class UserRepository {
  final UserProvider provider;

  UserRepository(this.provider);

  Future<dynamic> getUserAndPosts(
          {required String targetProfileId, required String myProfileId}) =>
      provider.getUserAndPosts(targetProfileId, myProfileId);

  Future<void> toggleFollowing(
          {required String source,
          required String type,
          required String profileId}) =>
      provider.toggleFollowing(source, type, profileId);
}
