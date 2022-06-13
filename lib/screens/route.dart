import 'dart:js';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:todoappflutter/screens/admin_addupdate_task_.dart';
import 'package:todoappflutter/screens/admin_users_screen.dart';
import '../models/model.dart';
import '../blocs/auth/auth.dart';
import 'signup_screen.dart';
import 'splash_screen.dart';
import 'admin_home_screen.dart';
import 'login_screen.dart';
import 'user_home_screen.dart';

bool isAuthenticated = false;
bool isAdmin = false;

class AppRoutes {
  static Route generateRoute(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(
          builder: (context) =>
              BlocBuilder<AuthBloc, AuthStates>(builder: (context, state) {
                if (state is AutoLoginState) {
                  return SplashScreen(title: 'Authenticating');
                } else if (state is AutoLoginSuccessState) {
                  isAdmin = state.user.role!.name!.toUpperCase() == 'ADMIN';
                  isAuthenticated = true;
                } else if (state is AutoLoginFailedState) {
                  isAuthenticated = false;
                } else if (state is LoggingOutState) {
                  return SplashScreen(title: 'Logging out');
                } else if (state is LoggingOutSuccessState) {
                  isAuthenticated = false;
                } else if (state is LoggingOutErrorState) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('An Error Occurred!'),
                      content: Text('Failed to log out'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Okay'),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                        )
                      ],
                    ),
                  );
                }
                return isAuthenticated
                    ? (isAdmin ? AdminHome() : UserHome())
                    : LoginScreen();
              }));
    }

    if (settings.name == LoginScreen.routeName) {
      return MaterialPageRoute(builder: (context) => LoginScreen());
    }
    if (settings.name == SignUpScreen.routeName) {
      return MaterialPageRoute(builder: (context) => SignUpScreen());
    }
    if (settings.name == AdminHome.routeName) {
      return MaterialPageRoute(builder: (context) => AdminHome());
    }

    // if (settings.name == TaskAddUpdate.routeName) {
    //   TaskRoutArgs taskRoutArgs = settings.arguments;
    //   return MaterialPageRoute(
    //       builder: (context) => TaskAddUpdate(
    //             taskRoutArgs: taskRoutArgs,
    //           ));
    // }

    if (settings.name == AdminUsersScreen.routeName) {
      return MaterialPageRoute(builder: (context) => AdminUsersScreen());
    }

return MaterialPageRoute(builder: (context) =>SplashScreen(title: "nothing happens"));

  
}

}

class TaskRoutArgs {
  final Task? task;
  final bool? edit;

  TaskRoutArgs({this.task, this.edit});
}


class TaskRoutArgsForDetail {
  final Task? task;
  TaskRoutArgsForDetail({this.task});
}

