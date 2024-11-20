import '../provider/account_provider.dart';

class AccountRepository {
  final AccountProvider provider;

  AccountRepository(this.provider);

  Future<dynamic> fetchAccount(String id) async {
    return await provider.fetchAccount(id);
  }
}
