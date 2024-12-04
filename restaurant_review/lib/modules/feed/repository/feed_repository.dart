import '../provider/feed_provider.dart';

class FeedRepository {
  final FeedProvider provider;

  FeedRepository(this.provider);

  Future<dynamic> fetchPostDetail(int id) async {
    return await provider.fetchPostDetail(id);
  }
}
