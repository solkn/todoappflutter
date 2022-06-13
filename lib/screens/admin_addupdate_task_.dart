import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoappflutter/blocs/task/task.dart';
import 'package:todoappflutter/models/model.dart';
import 'package:todoappflutter/screens/route.dart';

class TaskAddUpdate extends StatefulWidget {
  static const routeName = "admin_add_result";
  final TaskRoutArgs? taskRoutArgs;
  TaskAddUpdate({this.taskRoutArgs});
  @override
  TaskAddUpdateState createState() {
    return TaskAddUpdateState();
  }
}

class TaskAddUpdateState extends State<TaskAddUpdate> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>();
  
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _dateFocusNode = FocusNode();
  final _statusFocusNode = FocusNode();
  final _assignedToFocusNode =FocusNode();

  String? title;
  String? description;
  DateTime? date;
  String? status;
  String? assignedTo;





  Task task = Task();
  bool isInit = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit && widget.taskRoutArgs!.edit!) {
      title = widget.taskRoutArgs!.task!.title;
      description = widget.taskRoutArgs!.task!.description;
      date = widget.taskRoutArgs!.task!.date;
      status = widget.taskRoutArgs!.task!.status;
      assignedTo = widget.taskRoutArgs!.task!.assignedTo;

      isInit = true;
    }
  }
  

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _dateFocusNode.dispose();
    _statusFocusNode.dispose();
    _assignedToFocusNode.dispose();

    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    if (widget.taskRoutArgs!.edit!) {
      task = Task(
      id: widget.taskRoutArgs!.task!.id,
      title: widget.taskRoutArgs!.task!.title,
      description: widget.taskRoutArgs!.task!.description,
      date: widget.taskRoutArgs!.task!.date,
      status: widget.taskRoutArgs!.task!.status,
      assignedTo: widget.taskRoutArgs!.task!.assignedTo,
      );

      BlocProvider.of<TasksBloc>(context, listen: false)
        ..add(UpdateTasksEvent(task: task));
    } else {
      task = Task(
        title: widget.taskRoutArgs!.task!.title,
        description: widget.taskRoutArgs!.task!.description,
        date: widget.taskRoutArgs!.task!.date,
        status: widget.taskRoutArgs!.task!.status,
        assignedTo: widget.taskRoutArgs!.task!.assignedTo,
      );

      BlocProvider.of<TasksBloc>(context, listen: false)
        ..add(PostTasksEvent(task: task));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title:
            widget.taskRoutArgs!.edit! ? Text("Update Task") : Text("Add Task"),
        actions: [
          IconButton(
              icon: Icon(
                Icons.save,
                color: Colors.white,
              ),
              onPressed: _saveForm)
        ],
      ),
      body: BlocConsumer<TasksBloc, TaskStates>(
        listener: (_, state) {
   
          if (state is TaskPostingErrorState) {
      
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("erro while adding task"))
            
            );

          }
          if (state is TaskUpdatingState) {
        
           ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("erro while updating task"))
            
            );
          // }
          if ((state is TaskPostedState) || (state is TaskUpdatedState)) {
            BlocProvider.of<TasksBloc>(context).add(GetTasksEvent());
            BlocProvider.of<TasksBloc>(context).add(GetTasksEvent());
            Navigator.pop(context);
          }
          }
          },
        builder: (_, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                    child: TextFormField(
                      initialValue: widget.taskRoutArgs!.edit!
                          ? widget.taskRoutArgs!.task!.title
                          : "",
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      focusNode: _titleFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_titleFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'invalid input';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        title = value!;
                      },
                      decoration:  InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: widget.taskRoutArgs!.edit!
                              ? widget.taskRoutArgs!.task!.title
                              : "",
                          hintText: 'Enter Title'),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),

                   Padding(
                    padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                    child: TextFormField(
                      initialValue: widget.taskRoutArgs!.edit!
                          ? widget.taskRoutArgs!.task!.title
                          : "",
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      focusNode: _descriptionFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'invalid input';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        description = value!;
                      },
                      decoration:  InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: widget.taskRoutArgs!.edit!
                              ? widget.taskRoutArgs!.task!.description
                              : "",
                          hintText: 'Enter Description'),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
