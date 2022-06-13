import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoappflutter/blocs/auth/auth_blocs.dart';
import 'package:todoappflutter/blocs/auth/auth_events.dart';
import 'package:todoappflutter/blocs/task/task.dart';
import 'package:todoappflutter/data_provider/role_data.dart';
import 'package:todoappflutter/data_provider/task_data.dart';
import 'package:todoappflutter/repository/task_repository.dart';
import 'bloc_observer.dart';
import 'blocs/user/user.dart';
import 'repository/role_repository.dart';
import 'data_provider/data.dart';
import 'repository/repository.dart';
import 'blocs/role/role.dart';
import 'screens/route.dart';
import 'util/util.dart';
import 'package:http/http.dart' as http;
import 'repository/user_repository.dart';

void main() {
  //Bloc.observer = SimpleBlocObserver();

  final UserRepository userRepository = UserRepository(
      userDataProvider: UserDataProvider(httpClient: http.Client()));
  TaskRepository taskRepository = TaskRepository(
      taskDataProvider: TaskDataProvider(httpClient: http.Client()));
  RoleRepository roleRepository = RoleRepository(
      roleDataProvider: RoleDataProvider(httpClient: http.Client()));

  runApp(SoccerApp(
    userRepository: userRepository,
    taskRepository: taskRepository,
    roleRepository: roleRepository,
  ));
}

class SoccerApp extends StatelessWidget {
  final UserRepository userRepository;
  final TaskRepository taskRepository;
  final RoleRepository roleRepository;

  SoccerApp({
    required this.roleRepository,
    required this.userRepository,
    required this.taskRepository,
  }) : assert(userRepository != null &&
            taskRepository != null &&
            roleRepository != null);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (_) => this.userRepository,
        ),
        RepositoryProvider<TaskRepository>(
          create: (_) => this.taskRepository,
        ),
    
        RepositoryProvider<RoleRepository>(
          create: (_) => this.roleRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) =>
                AuthBloc(userRepository: this.userRepository, util: Util())
                  ..add(AutoLoginEvent()),
          ),
          BlocProvider<TasksBloc>(
            create: (_) => TasksBloc(taskRepository: this.taskRepository)
              ..add(
                GetTasksEvent(),
              ),
          ),
     
          BlocProvider<RoleBloc>(
            create: (_) => RoleBloc(roleRepository: this.roleRepository)
              ..add(GetRoleEvent()),
          ),
          BlocProvider<UserBloc>(
            create: (_) => UserBloc(userRepository: this.userRepository)
              ..add(GetUsersEvent()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todo App',
          initialRoute: '/',
          onGenerateRoute: AppRoutes.generateRoute,
        ),
      ),
    );
  }
}
