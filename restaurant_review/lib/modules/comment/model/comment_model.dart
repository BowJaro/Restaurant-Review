import 'package:get/get.dart';
import 'package:restaurant_review/global_classes/mini_reaction.dart';
import 'package:restaurant_review/global_classes/reaction_count.dart';

abstract class BaseCommentModel {
  final int id;
  final String profileId;
  final String content;
  final DateTime createdAt;
  final String? avatarUrl;
  final String? fullName;
  Rx<MiniReactionModel>? myReaction;
  final List<ReactionCount>? reactionCounts;

  BaseCommentModel({
    required this.id,
    required this.profileId,
    required this.content,
    required this.createdAt,
    required this.avatarUrl,
    required this.fullName,
    required this.myReaction,
    required this.reactionCounts,
  });
}

class CommentModel extends BaseCommentModel {
  final List<ReplyModel>? replies;

  CommentModel({
    required super.id,
    required super.profileId,
    required super.content,
    required super.createdAt,
    required super.avatarUrl,
    required super.fullName,
    required super.reactionCounts,
    required super.myReaction,
    required this.replies,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['comment_id'],
      profileId: map['profile_id'],
      content: map['content'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      avatarUrl: map['avatar_url'],
      fullName: map['full_name'],
      myReaction: map['my_reaction'] == null
          ? null
          : MiniReactionModel.fromMap(
                  map['my_reaction'] as Map<String, dynamic>)
              .obs,
      replies: map['replies'] == null
          ? null
          : (map['replies'] as List<dynamic>)
              .map((item) => ReplyModel.fromMap(item as Map<String, dynamic>))
              .toList(),
      reactionCounts: map['reaction_list'] == null
          ? null
          : (map['reaction_list'] as List<dynamic>)
              .map(
                  (item) => ReactionCount.fromMap(item as Map<String, dynamic>))
              .toList(),
    );
  }
}

class ReplyModel extends BaseCommentModel {
  ReplyModel({
    required super.id,
    required super.profileId,
    required super.content,
    required super.createdAt,
    required super.avatarUrl,
    required super.fullName,
    required super.myReaction,
    required super.reactionCounts,
  });

  factory ReplyModel.fromMap(Map<String, dynamic> map) {
    return ReplyModel(
      id: map['comment_id'],
      profileId: map['profile_id'],
      content: map['content'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      avatarUrl: map['avatar_url'],
      fullName: map['full_name'],
      myReaction: map['my_reaction'] == null
          ? null
          : MiniReactionModel.fromMap(
                  map['my_reaction'] as Map<String, dynamic>)
              .obs,
      reactionCounts: map['reaction_list'] == null
          ? null
          : (map['reaction_list'] as List<dynamic>)
              .map(
                  (item) => ReactionCount.fromMap(item as Map<String, dynamic>))
              .toList(),
    );
  }
}
