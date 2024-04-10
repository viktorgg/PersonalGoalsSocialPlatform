import 'package:goals_social_network/models/user.dart';

class Goal {
  final int id;
  final String title;
  final String description;
  bool done;
  final User userOwner;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.done,
    required this.userOwner,
  });

  factory Goal.fromMap(Map goalMap) {
    return Goal(
        id: goalMap['id'],
        title: goalMap['title'],
        description: goalMap['description'],
        done: goalMap['done'],
        userOwner: User.fromMap(goalMap['userOwner']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'done': done,
    };
  }

  void toggle() {
    done = !done;
  }
}