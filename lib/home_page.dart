import 'package:flutter/material.dart';
import 'add_task_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    tasks.add({
      'title': 'Mobile Programming',
      'details': 'Learn Flutter for mobile development.',
      'date': DateTime(2024, 10, 10),
      'time': TimeOfDay(hour: 10, minute: 0),
      'isChecked': false,
    });
    _checkTaskStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Activities'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 225, 193, 204),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ExpansionTile(
                        leading: Checkbox(
                          value: tasks[index]['isChecked'],
                          onChanged: (value) {
                            setState(() {
                              tasks[index]['isChecked'] = value!;
                            });
                          },
                        ),
                        title: Text(
                          tasks[index]['title']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${DateFormat.yMd().format(tasks[index]['date'])} at ${tasks[index]['time']!.format(context)}',
                        ),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            color: Colors.pink[50],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    tasks[index]['details']!,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      tasks.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                onPressed: () {
                  _navigateToAddTaskScreen(context);
                },
                icon: const Icon(Icons.add_circle_outline),
                iconSize: 60,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddTaskScreen(BuildContext context) async {
    final newTask = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskPage()),
    );

    if (newTask != null) {
      setState(() {
        tasks.add(newTask);
      });
      _checkTaskStatus();
    }
  }

  void _checkTaskStatus() {
    final now = DateTime.now();
    for (var task in tasks) {
      DateTime taskDateTime = DateTime(
        task['date'].year,
        task['date'].month,
        task['date'].day,
        task['time'].hour,
        task['time'].minute,
      );

      if (taskDateTime.isBefore(now)) {
        task['isChecked'] = true;
      }
    }
  }
}
