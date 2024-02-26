import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<String> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  late final List<bool> _tasksCompleted;

  @override
  void initState() {
    super.initState();
    _tasksCompleted = List<bool>.generate(_tasks.length, (index) => false);
  }



  void _addTask(String task) {
    setState(() {
      _tasks.add(task);
      _tasksCompleted.add(false); // Add false for the new task
    });
  }



  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple[100]!,
              Colors.cyan[100]!
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
          )
        ),
          child: _buildTaskList(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final task = await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                title: const Text('Add Task'),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _taskController,
                      decoration: const InputDecoration(
                        labelText: 'Task',
                      ),
                      onSubmitted: (value) {
                        // Handle form submission here if needed
                      },
                    ),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      ElevatedButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        child: Text('Add'),
                        onPressed: () {
                          // Retrieve the task entered by the user
                          String task = _taskController.text;
                          // Add the task to the list
                          _addTask(task);
                          // Clear the text field
                          _taskController.clear();
                          // Close the dialog
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          );
          if (task != null) {
            _addTask(task);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            _tasks[index],
            style: TextStyle(
              decoration: _tasksCompleted[index]
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: _tasksCompleted[index],
                onChanged: (bool? value) {
                  setState(() {
                    _tasksCompleted[index] = value ?? false;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _removeTask(index),
              ),
            ],
          ),
        );
      },
    );
  }

}

