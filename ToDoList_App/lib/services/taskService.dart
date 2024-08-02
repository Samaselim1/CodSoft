import 'package:flutter/material.dart';
import 'package:flutter_project/model/task.dart';
import '../model/task.dart';

class TaskService {
  static List<Task> _tasks = [];

  static Future<List<Task>> getTask() async {
    return _tasks;
  }

  static Future<void> addTask(Task t) async {
    _tasks.add(t);
    print('Task "${t.title}" is added.');
  }

  static Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    print('Task is deleted.');
  }

  static Future<void> updateTask(Task t) async {
    int index = _tasks.indexWhere((task) => task.id == t.id);
    if (index != -1) {
      _tasks[index] = t;
    }
    print('Task "${t.title}" is updated.');
  }

  static List<Task> filterTasks(String query, List<Task> tasks) {
    query = query.toLowerCase();
    return tasks.where((task) {
      return task.title.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query);
    }).toList();
  }

  static Future<Task> TaskCompletion(Task t) async {
    final updatedTask = t.copyWith(isDone: !t.isDone);
    await updateTask(updatedTask);
    return updatedTask;
    print('Task "${t.title}" is completed.');
  }
}
