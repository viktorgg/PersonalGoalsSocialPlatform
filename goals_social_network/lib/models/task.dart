class Task {
  final int id;
  final String title;
  final String description;

  Task({
    required this.id,
    required this.title,
    required this.description
  });

  factory Task.fromMap(Map taskMap) {
    return Task(id: taskMap['id'], title: taskMap['title'], description: taskMap['description']);
  }


}