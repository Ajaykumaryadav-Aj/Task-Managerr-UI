class Task {
  final String title;
  final String description;
  final String assignee;
  DateTime startDate;
  TaskStatus status;
  final bool highPriority;

  Task({
    required this.title,
    required this.description,
    required this.assignee,
    required this.startDate,
    required this.status,
    this.highPriority = false,
  });
}


enum TaskStatus {
  notStarted,
  started,
  completed,
}