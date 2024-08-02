import 'package:flutter/material.dart';
import '../model/task.dart';
import '../services/taskService.dart';
import '../widgets/taskItem.dart';
import '../screens/taskScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  List<Task> filteredTasks = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks();
    searchController.addListener(() {
      filterTasks();
    });
  }

  void loadTasks() async {
    tasks = await TaskService.getTask();
    filteredTasks = tasks;
    setState(() {});
  }

  void filterTasks() {
    setState(() {
      filteredTasks = TaskService.filterTasks(searchController.text, tasks);
    });
  }

  void taskCompletion(Task task) async {
    final updatedTask = await TaskService.TaskCompletion(task);
    setState(() {
      tasks =
          tasks.map((t) => t.id == updatedTask.id ? updatedTask : t).toList();
      filterTasks();
    });
  }

  void deleteTask(Task task) async {
    await TaskService.deleteTask(task.id);
    setState(() {
      tasks.removeWhere((t) => t.id == task.id);
      filterTasks();
    });
    showSuccessDialog('Task deleted successfully');
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
      appBar: AppBar(
        title: const Text("TO-DO List App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.grey[600]),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filteredTasks.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (ctx, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TaskItem(
                            task: filteredTasks[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      TaskScreen(task: filteredTasks[index]),
                                ),
                              ).then((_) => loadTasks());
                            },
                            onToggleComplete: (bool? isChecked) {
                              taskCompletion(filteredTasks[index]);
                            },
                            onDelete: () => deleteTask(filteredTasks[index]),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No tasks found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => TaskScreen(),
            ),
          ).then((_) => loadTasks());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
