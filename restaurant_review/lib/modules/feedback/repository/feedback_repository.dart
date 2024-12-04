import '../provider/feedback_provider.dart';

class FeedbackRepository {
  final FeedbackProvider provider;

  FeedbackRepository(this.provider);

  Future<void> insertFeedback({
    required String title,
    required String description,
  }) async {
    return await provider.insertFeedback(title, description);
  }
}
