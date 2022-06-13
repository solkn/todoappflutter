
import 'package:todoappflutter/util/util.dart';

Util util =  Util();

class Task {
  int? id;
  String? title;
  String? description;
  DateTime? date;
  String? status;
  String? assignedTo;

  Task({
     this.id,
     this.title,
     this.description,
     this.date,
     this.status,
     this.assignedTo,

  });
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      date: util.getDateTimeFromString(json["date"]),
      status: json["status"],
      assignedTo: json["assignedTo"]

    );
  }

 Map toJson() => {
        'id': id,
        'title':title,
        'description': description,
        'date': date,
        'status': status,
        'assignedTo': assignedTo,
      };

}

