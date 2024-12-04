class ReactionCount {
  final String name;
  final int number;

  ReactionCount({required this.name, required this.number});

  factory ReactionCount.fromMap(Map<String, dynamic> map) {
    return ReactionCount(
      name: map['name'],
      number: map['number'],
    );
  }
}
