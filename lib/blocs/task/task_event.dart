import 'package:equatable/equatable.dart';
import 'package:todoappflutter/models/model.dart';

abstract class TaskEvents extends Equatable {}

class GetTasksEvent extends TaskEvents {
  GetTasksEvent();
  @override
  List<Object> get props => [];
}

class PostTasksEvent extends TaskEvents {
  final Task task;
  PostTasksEvent({required this.task});
  @override
  List<Object> get props => [];
}

class UpdateTasksEvent extends TaskEvents {
  final Task task;
  UpdateTasksEvent({required this.task});
  @override
  List<Object> get props => [];
}

class DeleteTasksEvent extends TaskEvents {
  final int id;
  DeleteTasksEvent({required this.id});

  @override
  List<Object> get props => [];
}
