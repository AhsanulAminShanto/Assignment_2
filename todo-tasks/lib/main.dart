import 'package:flutter/material.dart';
import 'package:todo_tasks/todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo Tasks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MainWidget(),
    );
  }
}

class MainWidget extends StatelessWidget {
  final ValueNotifier<List<Todo>> _todos = ValueNotifier<List<Todo>>(
    [
      Todo(
        title: 'Buy milk',
      ),
      Todo(
        title: 'Buy eggs',
      ),
      Todo(
        title: 'Buy bread',
      ),
    ],
  );

  MainWidget({super.key});

  void _addTodo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add a new task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Task title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final String title = controller.text;
                if (title.isNotEmpty) {
                  _todos.value = [
                    ..._todos.value,
                    Todo(
                      title: title,
                    ),
                  ];
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
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
        title: const Text('My Tasks'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ValueListenableBuilder<List<Todo>>(
        valueListenable: _todos,
        builder: (context, todos, child) {
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final Todo todo = todos[index];
              return CheckboxListTile(
                value: todo.isDone,
                title: Text(
                  todo.title,
                  style: todo.isDone
                      ? const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 2,
                        )
                      : null,
                ),
                onChanged: (value) {
                  todo.isDone = value ?? false;
                  _todos.value[index] = todo;
                  _todos.value = [..._todos.value];
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodo(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
