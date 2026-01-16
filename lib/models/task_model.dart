import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

@JsonSerializable()
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

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
  Map<String, dynamic> toCreateJson() {
    return {'title': title, 'description': description, 'status': status};
  }

  bool get isCompleted => status == 'completada';
  bool get isPending => status == 'pendiente';
}
