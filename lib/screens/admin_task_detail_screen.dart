import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AdminTaskDetail extends StatelessWidget {
  static const routeName = 'taskDetail';
  final AdminTaskDetail? task;

  AdminTaskDetail({ this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${this.task}' ),

      ),
      body:
         Center(
           child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "--------------------------------------------",
                style: TextStyle(color: Colors.redAccent),
              ),


              Text('title: ${this.task!}'),
              Text(
                "--------------------------------------------",
                style: TextStyle(color: Colors.redAccent),
              ),
              SizedBox(
                height: 10,
              ),
               
            ],
        ),
         ),

    );
  }
}
