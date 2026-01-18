import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Task {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String status;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  Map<String, dynamic> toUpdateJson() {
    return {'title': title, 'description': description, 'status': status};
  }

  bool get isCompleted => status == 'completada';
  bool get isPending => status == 'pendiente';
}
