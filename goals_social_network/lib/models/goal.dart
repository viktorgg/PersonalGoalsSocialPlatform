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

  factory Goal.fromMap(Map taskMap) {
    return Goal(id: taskMap['id'], title: taskMap['title'], description: taskMap['description'],  done: taskMap['done']);
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