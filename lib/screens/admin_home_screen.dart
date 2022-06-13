import 'package:flutter/material.dart';
import 'package:todoappflutter/screens/admin_addupdate_task_.dart';
import 'package:todoappflutter/screens/user_task_screen.dart';
import '../widgets/app_drawer_admin.dart';
import 'route.dart';

class AdminHome extends StatefulWidget {
  static const routeName = 'admin_home';

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TabController? controller;
  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Todo'),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  TaskAddUpdate.routeName,
                  arguments: TaskRoutArgs(edit: false),
                );
              })
        ],
        bottom: TabBar(
          controller: controller,
          tabs: [
            Tab(
              text: "Tasks",
            ),
          ],
        ),
      ),
      drawer: AppDrawer(),
      body: TabBarView(controller: controller, children: <Widget>[
     
        UserTasksScreen(
        )
      ]),
    );
  }
}
