class Task {
  final String id;
  final String title;
  final String description;
  final String category;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.isDone = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    bool? isDone,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isDone: isDone ?? this.isDone,
    );
  }
}
