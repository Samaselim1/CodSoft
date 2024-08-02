import 'package:flutter/material.dart';
import '../model/task.dart';
import '../services/taskService.dart';

class TaskScreen extends StatefulWidget {
  final Task? task;

  TaskScreen({this.task});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _category;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController = TextEditingController(text: widget.task!.title);
      _descriptionController =
          TextEditingController(text: widget.task!.description);
      _category = widget.task!.category;
    } else {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
      _category = '';
    }
  }

  void showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(widget.task == null ? "New Task" : "Edit Task")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (widget.task == null) {
                  await TaskService.addTask(Task(
                    id: DateTime.now().toString(),
                    title: _titleController.text,
                    description: _descriptionController.text,
                    category: _category,
                  ));
                  showSuccessDialog('Task added successfully');
                } else {
                  await TaskService.updateTask(Task(
                    id: widget.task!.id,
                    title: _titleController.text,
                    description: _descriptionController.text,
                    isDone: widget.task!.isDone,
                    category: _category,
                  ));
                  showSuccessDialog('Task updated successfully');
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Save", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
