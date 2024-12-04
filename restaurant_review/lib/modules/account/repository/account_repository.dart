import 'package:flutter/material.dart';

import '../model/account_update_model.dart';
import '../provider/account_provider.dart';

class AccountRepository {
  final AccountProvider provider;

  AccountRepository(this.provider);

  Future<dynamic> fetchAccount(String id) async {
    return await provider.fetchAccount(id);
  }

  Future<bool> updateAccount(AccountUpdateModel accountUpdateModel) async {
    return await provider.updateAccount(accountUpdateModel);
  }

  Future<dynamic> updateEmail(String newEmail, String userId) async {
    return await provider.updateEmail(newEmail, userId);
  }

  Future<bool> verifyPassword(String currentPassword, String userId) async {
    return await provider.verifyPassword(currentPassword, userId);
  }

  Future<dynamic> updatePassword(String newPassword) async {
    return await provider.updatePassword(newPassword);
  }

  Future<dynamic> subscribeAcccountData(VoidCallback getData) async {
    return await provider.subscribeAcccountData(getData);
  }

  Future<void> unsubscribeAcccountData(channel) async {
    await provider.unsubscribeAcccountData(channel);
  }
}
