import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:todoappflutter/models/model.dart';
import 'package:http/http.dart' as http;
import '../util/util.dart';

class TaskDataProvider {
  final http.Client httpClient;

  TaskDataProvider({required this.httpClient}) : assert(httpClient != null);

  Future<List<Task>> getAndSetTasks() async {
    List<Task> tasks = [];
    final uri = 'https://mtodo-api.herokuapp.com/api/v1/tasks/';
    try {
      final response = await httpClient.get(Uri.parse(uri));
      print(response.statusCode);
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body) as List<dynamic>;
        if (extractedData == null) {
          //return null;
        }
        tasks = extractedData
            .map<Task>((json) => Task.fromJson(json))
            .toList();
        print(tasks);
      } else {
        throw HttpException("Error Occurred");
      }
    } catch (e) {
      throw e;
    }
    return tasks;
  }

  Future<Task> getTask(int taskId) async {
    Task task;
    final uri = 'https://mtodo-api.herokuapp.com/api/v1/tasks/$taskId';
    try {
      final response = await httpClient.get(
        Uri.parse(uri),
      );
      if (response.statusCode == 500) {
        throw HttpException('Error Occurred');
      } else if (response.statusCode == 404) {
        throw HttpException('Fixture Not Found');
      } else {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        task = Task.fromJson(extractedData);
      }
    } catch (e) {
      throw e;
    }
    return task;
  }

  Future<Task> postTask(Task task) async {
    Task? tk;
    final uri = 'https://mtodo-api.herokuapp.com/api/v1/tasks/';
    Util util =  Util();
    String token = await util.getUserToken();
    try {
   
      final response = await httpClient.post(
        Uri.parse(uri),
        body: json.encode(
          {
            'id': task.id,
            'title':task.title,
            'date':task.date!.millisecondsSinceEpoch.toString(),
            'status':task.status,
            'assignedTo': task.assignedTo,
          },
        ),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        tk = Task.fromJson(extractedData);
      } else {
        throw HttpException('Error Occurred');
      }
    } catch (e) {
      throw e;
    }
    return tk;
  }

  Future<Task> putTask(Task task) async {
    Task? tk;
    final uri = 'https://mtodo-api.herokuapp.com/api/v1/tasks/${task.id}';
    String token = await util.getUserToken();
    try {

      final response = await httpClient.put(
        Uri.parse(uri),
        body: json.encode(
          {
            'id': task.id,
            'title':task.title,
            'date':task.date!.millisecondsSinceEpoch.toString(),
            'status':task.status,
            'assignedTo': task.assignedTo,
          },
        ),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: "Bearer $token"
        },
      );
      if (response.statusCode == 500) {
        throw HttpException('Error Occurred');
      } else {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        task = Task.fromJson(extractedData);
      }
    } catch (e) {
      throw e;
    }
    return task;
  }

  Future<void> deleteTask(int id) async {
    final uri = 'https://mtodo-api.herokuapp.com/api/v1/tasks/';
    Util util =  Util();
    String token = await util.getUserToken();
    try {
      final response = await httpClient.delete(
        Uri.parse(uri),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      );
      print(response.statusCode);
      if (response.statusCode == 500) {
        throw HttpException('Error Occurred');
      } else if (response.statusCode == 404) {
        throw HttpException('task Not Found');
      } else {
        return;
      }
    } catch (e) {
      throw e;
    }
  }
}
