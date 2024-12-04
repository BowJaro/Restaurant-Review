import '../provider/report_provider.dart';

class ReportRepository {
  final ReportProvider provider;

  ReportRepository(this.provider);

  Future<void> insertReport(
      {required String source,
      required String type,
      required String title,
      required String description}) async {
    return await provider.insertReport(
        source: source, type: type, title: title, description: description);
  }
}
