import 'package:flutter/material.dart';
import 'package:todoappflutter/widgets/app_drawer_user.dart';
import 'user_task_screen.dart';

class UserHome extends StatefulWidget {
  static const routeName = 'user_home';

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  @override
  void initState() {
    super.initState();
    controller =  TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'),
        bottom: TabBar(
          controller: controller,
          tabs: [
            Tab(
              text: "Tasks",
            ),
          ],
        ),
      ),
      drawer: UserAppDrawer(),
      body: TabBarView(
          controller: controller,
          children: 
          <Widget>[
            UserTasksScreen()
             ]),
    );
  }
}
