import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationProvider {
  final SupabaseClient supabase;

  NotificationProvider(this.supabase);

  /// Fetch all rows of table notification which has notification.profile_id = parameter
  Future<dynamic> fetchNotificationsByProfileId(String profileId) async {
    try {
      final response = await supabase
          .rpc('get_user_notifications', params: {'p_profile_id': profileId});
      return response;
    } on PostgrestException catch (error) {
      print('Error fetching notifications: ${error.message}');
      return null;
    } catch (error) {
      print('Unknown error fetching notifications: $error');
      return null;
    }
  }

  /// Remove a notification by id
  Future<void> removeNotification(int notificationId) async {
    try {
      await supabase.from('notification').delete().eq('id', notificationId);
    } on PostgrestException catch (error) {
      print('Error removing notification: ${error.message}');
    } catch (error) {
      print('Unknown error removing notification: $error');
    }
  }

  /// Toggle the is_read field of a notification
  Future<void> toggleIsRead(int notificationId, bool isRead) async {
    try {
      await supabase
          .from('notification')
          .update({'is_read': isRead}).eq('id', notificationId);
    } on PostgrestException catch (error) {
      print('Error toggling is_read of notification: ${error.message}');
    } catch (error) {
      print('Unknown error toggling is_read of notification: $error');
    }
  }
}
