class Task {
  String? id;
  String title;
  String description;
  String status;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.status,
  });
  factory Task.fromJson(Map<String, dynamic> json) 
  => Task(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    status: json['status'],
  );
  Map<String, dynamic> toJson() => {
    'id':id,
    'title': title,
    'description': description,
    'status': status,
  };
  bool get isCompleted => status == 'completado';
}
