class Goal {
  final int id;
  final String title;
  final String description;
  bool done;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.done,
  });

  factory Goal.fromMap(Map goalMap) {
    return Goal(
        id: goalMap['id'],
        title: goalMap['title'],
        description: goalMap['description'],
        done: goalMap['done']
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