import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoappflutter/blocs/task/task.dart';
import 'package:todoappflutter/widgets/task_comp_admin.dart';
import 'splash_screen.dart';

class UserTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksBloc, TaskStates>(
      listener: (context, state) {},
      builder: (_, state) {
        if (state is TaskFetchingState) {
          return SplashScreen(title: 'Fetching tasks');
        } else if (state is TaskFetchedState) {
          
          final tasks = state.tasks;

          return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: tasks.length,
              itemBuilder: (_, idx) =>
                  TaskComponentAdmin(task: tasks[idx]));
        } else if (state is TaskEmptyState) {
          return SplashScreen(title: 'No tasks Added');
        } else {
          return SplashScreen(title: 'Failed to load tasks');
        }
      },
    );
  }
}
