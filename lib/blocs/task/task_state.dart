
import 'package:todoappflutter/models/model.dart';

abstract class TaskStates {}

class TaskUninitializedState extends TaskStates {}

class TaskFetchingState extends TaskStates {}

class TaskFetchedState extends TaskStates {
  final List<Task> tasks;
  TaskFetchedState({required this.tasks});
}

class TaskFetchingErrorState extends TaskStates {
  final String? message;

  TaskFetchingErrorState({this.message});
}

class TaskDeletingState extends TaskStates {}

class TaskDeletedState extends TaskStates {}

class TaskDeletingErrorState extends TaskStates {
  final String ?message;

  TaskDeletingErrorState({this.message});
}

class TaskPostingState extends TaskStates {}

class TaskPostedState extends TaskStates {}

class TaskPostingErrorState extends TaskStates {
  final String ?message;

  TaskPostingErrorState({this.message});
}

class TaskUpdatingState extends TaskStates {}

class TaskUpdatedState extends TaskStates {}

class TaskUpdatingErrorState extends TaskStates {
  final String ?message;
  TaskUpdatingErrorState({this.message});
}

class TaskEmptyState extends TaskStates {}
