import 'package:flutter/material.dart';

class Task {
  String title;
  bool isCompleted;

  Task(this.title, {this.isCompleted = false});
}

class ToDoHomePage extends StatefulWidget {
  @override
  _ToDoHomePageState createState() => _ToDoHomePageState();
}

class _ToDoHomePageState extends State<ToDoHomePage> {
  List<Task> tasks = [
    Task("Buy groceries"),
    Task("Read a book"),
    Task("Go for a walk"),
  ];

  TextEditingController taskController = TextEditingController();

  void _addTask() {
    String text = taskController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        tasks.add(Task(text));
        taskController.clear();
      });
    }
  }

  void _toggleTask(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  void _showCompletedTasksReport() {
    List<Task> completedTasks =
    tasks.where((task) => task.isCompleted).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Completed Tasks"),
        content: completedTasks.isEmpty
            ? Text("No tasks completed yet.")
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: completedTasks
              .map((task) => ListTile(
            leading: Icon(Icons.check, color: Colors.green),
            title: Text(task.title),
          ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo List"),
        actions: [
          IconButton(
            icon: Icon(Icons.analytics_outlined),
            tooltip: "Completed Tasks Report",
            onPressed: _showCompletedTasksReport,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      labelText: 'Enter new task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTask,
                  child: Text("Add"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, index) {
                final task = tasks[index];
                return CheckboxListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  value: task.isCompleted,
                  onChanged: (_) => _toggleTask(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
