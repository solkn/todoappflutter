import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:todoappflutter/models/model.dart';
import 'package:todoappflutter/repository/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TasksBloc extends Bloc<TaskEvents, TaskStates> {
  TaskRepository taskRepository;
  TasksBloc({required this.taskRepository})
      : super(TaskUninitializedState());

  @override
  Stream<TaskStates> mapEventToState(TaskEvents event) async* {
    if (event is GetTasksEvent) {
      yield* _mapGetTasksEventToState();
    } else if (event is PostTasksEvent) {
      yield* _mapPostTasksEventToState(event.task);
    } else if (event is UpdateTasksEvent) {
      yield* _mapUpdateTasksEventToState(event.task);
    } else if (event is DeleteTasksEvent) {
      yield* _mapDeleteTasksEventToState(event.id);
    }
  }

  Stream<TaskStates> _mapGetTasksEventToState() async* {
    yield TaskFetchingState();
    try {
      List<Task> tasks = await taskRepository.getAndSetTasks();
      if (tasks.length == 0) {
        yield TaskEmptyState();
      } else {
        yield TaskFetchedState(tasks: tasks);
      }
    } on HttpException catch (e) {
      yield TaskFetchingErrorState(message: e.message);
    } catch (e) {
      print(e.toString());
      yield TaskFetchingErrorState();
    }
  }

  Stream<TaskStates> _mapPostTasksEventToState(Task task) async* {
    yield TaskPostingState();
    try {
      await taskRepository.postTask(task);
      yield TaskPostedState();
    } on HttpException catch (e) {
      yield TaskPostingErrorState(message: e.message);
    } catch (e) {
      yield TaskPostingErrorState();
    }
  }

  Stream<TaskStates> _mapUpdateTasksEventToState(Task task) async* {
    yield TaskUpdatingState();
    try {
      await taskRepository.putTask(task);
      yield TaskUpdatedState();
    } on HttpException catch (e) {
      yield TaskUpdatingErrorState(message: e.message);
    } catch (e) {
      yield TaskUpdatingErrorState();
    }
  }

  Stream<TaskStates> _mapDeleteTasksEventToState(int id) async* {
    yield TaskDeletingState();
    try {
      await taskRepository.deleteTask(id);
      yield TaskDeletedState();
    } on HttpException catch (e) {
      yield TaskDeletingErrorState(message: e.message);
    } catch (e) {
      yield TaskDeletingErrorState();
    }
  }
}
