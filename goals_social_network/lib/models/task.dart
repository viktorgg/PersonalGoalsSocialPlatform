class Task {
  final int id;
  final String title;
  final String description;
  bool done;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.done = false,
  });

  factory Task.fromMap(Map taskMap) {
    return Task(id: taskMap['id'], title: taskMap['title'], description: taskMap['description'],  done: taskMap['done']);
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