class User {
  final int time;
  final String name;
  bool matched;

  User({
    required this.time,
    this.name = '',
    this.matched = false
  });
}