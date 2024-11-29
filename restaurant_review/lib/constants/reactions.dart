import 'package:flutter/material.dart';

// Map for reactions
final Map<String, IconData> _reactionIcons = {
  "like": Icons.thumb_up,
  "dislike": Icons.thumb_down,
  "default": Icons.thumb_up_alt_outlined,
};

// Default icon for unknown reactions
const IconData defaultReactionIcon = Icons.thumb_up;

/// Function to fetch the reaction icon with a fallback
IconData getReactionIcon(String reactionType) {
  return _reactionIcons[reactionType] ?? defaultReactionIcon;
}
