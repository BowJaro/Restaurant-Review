import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_review/modules/account/model/account_update_model.dart';
import 'package:restaurant_review/services/image_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountProvider {
  final SupabaseClient supabase;
  final ImageService imageService = ImageService();

  AccountProvider(this.supabase);

  Future<dynamic> fetchAccount(String id) async {
    try {
      final response =
          await supabase.rpc("get_profile_details", params: {"user_id": id});
      return response;
    } on PostgrestException catch (error) {
      print('=========Error fetching account: ${error.message}=========');
      return null;
    } catch (error) {
      print('=========Unknown error fetching account: $error=========');
      return null;
    }
  }

  Future<dynamic> subscribeAcccountData(VoidCallback getData) async {
    final channel = supabase
        .channel('public:profiles')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'profiles',
          callback: (payload) {
            print('Change received: ${payload.toString()}');
            // Call the passed function with the appropriate parameter
            getData(); // Assuming `id` is in `newRecord`
          },
        )
        .subscribe();

    return channel;
  }

  Future<void> unsubscribeAcccountData(channel) async {
    await supabase.removeChannel(channel);
  }

  Future<bool> updateAccount(AccountUpdateModel accountUpdateModel) async {
    String updatedAvatarUrl = "";

    // Check if avatar is a file or a URL
    if (accountUpdateModel.imageUrl is XFile) {
      updatedAvatarUrl = await imageService.uploadImage(
        accountUpdateModel.imageUrl,
        'images',
        'account/${accountUpdateModel.imageUrl.name}',
      );

      if (updatedAvatarUrl.isEmpty) {
        print('=========Failed to upload avatar=========');
        return false;
      }
    }

    print('accountUpdateModel ${accountUpdateModel.toMap()}');
    print('updatedAvatarUrl ${updatedAvatarUrl}');
    try {
      // Call the update_account function in Supabase
      await supabase.rpc('update_account', params: {
        'param_fullname': accountUpdateModel.fullName,
        'param_imageurl': updatedAvatarUrl,
        'param_phone': accountUpdateModel.phone,
        'userid': accountUpdateModel.userId,
        'param_username': accountUpdateModel.userName
      });

      return true;
    } on PostgrestException catch (e) {
      // Handle Postgrest-specific exceptions
      print('PostgrestException: ${e.message}');
      return false; // Operation failed
    } catch (e) {
      // Handle other unexpected exceptions
      print('Unexpected Error: $e');
      return false;
    }
  }

  Future<dynamic> updateEmail(String newEmail, String userId) async {
    try {
      final UserResponse res = await supabase.auth.updateUser(
        UserAttributes(
          email: "tam16121612@gmail.com",
        ),
      );
      final User? updatedUser = res.user;

      if (updatedUser != null) {
        final data = await supabase
            .from('profiles')
            .update({'email': newEmail})
            .eq('id', userId)
            .select();

        return data;
      } else {
        return null;
      }
    } on AuthException catch (error) {
      print('Error updating email: ${error.message}');
      return null;
    } catch (error) {
      print('Unknown error updating email: $error');
      return null;
    }
  }

  Future<bool> verifyPassword(String currentPassword, String userId) async {
    // Assuming the user is already authenticated
    final response = await supabase.rpc('verify_user_password',
        params: {'password': currentPassword, 'user_id': userId});

    // Check if the response data is true
    if (response == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> updatePassword(String newPassword) async {
    try {
      final UserResponse res = await supabase.auth.updateUser(
        UserAttributes(
          password: newPassword,
        ),
      );
      return res.user;
    } on AuthException catch (error) {
      print('Error updating email: ${error.message}');
      return null;
    } catch (error) {
      print('Unknown error updating email: $error');
      return null;
    }
  }
}
