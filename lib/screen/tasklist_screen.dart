import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/class/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [
    Task(
      title: 'Order-1043',
      description: 'Arrange Pickup',
      assignee: 'Sandhya',
      startDate: DateTime(2025, 8, 5),
      status: TaskStatus.started,
      highPriority: true,
    ),
    Task(
      title: 'Entity-2559',
      description: 'Adhoc Task',
      assignee: 'Arman',
      startDate: DateTime(2025, 8, 12),
      status: TaskStatus.started,
    ),
    Task(
      title: 'Order-1020',
      description: 'Collect Payment',
      assignee: 'Sandhya',
      startDate: DateTime(2025, 8, 15),
      status: TaskStatus.started,
      highPriority: true,
    ),
    Task(
      title: 'Order-194',
      description: 'Arrange Delivery',
      assignee: 'Prashant',
      startDate: DateTime(2025, 8, 20),
      status: TaskStatus.completed,
    ),
    Task(
      title: 'Entity-2184',
      description: 'Share Company Profile',
      assignee: 'Asif Khan K',
      startDate: DateTime(2025, 8, 22),
      status: TaskStatus.completed,
    ),
    Task(
      title: 'Entity-472',
      description: 'Add Followup',
      assignee: 'Avik',
      startDate: DateTime(2025, 8, 25),
      status: TaskStatus.completed,
    ),
    Task(
      title: 'Enquiry-3563',
      description: 'Convert Enquiry',
      assignee: 'Prashant',
      startDate: DateTime(2025, 8, 28),
      status: TaskStatus.notStarted,
    ),
    Task(
      title: 'Order-176',
      description: 'Arrange Pickup',
      assignee: 'Prashant',
      startDate: DateTime(2025, 9, 1),
      status: TaskStatus.notStarted,
      highPriority: true,
    ),
  ];

  void _startTask(int index) {
    setState(() {
      _tasks[index].status = TaskStatus.started;
    });
  }

  void _completeTask(int index) {
    setState(() {
      _tasks[index].status = TaskStatus.completed;
    });
  }

  Future<void> _editStartDate(int index) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _tasks[index].startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        _tasks[index].startDate = pickedDate;
      });
    }
  }

  String? _getOverdueDuration(Task task) {
    if (task.status == TaskStatus.completed) return null;

    final now = DateTime.now();
    if (task.startDate.isAfter(now)) return null;

    final diff = now.difference(task.startDate);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    return 'Overdue - ${hours}h ${minutes}m';
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          final isCompleted = task.status == TaskStatus.completed;
          final overdueText = _getOverdueDuration(task);
          final now = DateTime.now();

          String dueLabel = '';
          if (task.status != TaskStatus.completed) {
            if (task.startDate.isAfter(now)) {
              final diff = task.startDate.difference(now);
              if (diff.inDays == 1) {
                dueLabel = 'Due Tomorrow';
              } else if (diff.inDays > 1) {
                dueLabel = 'Due in ${diff.inDays} days';
              }
            }
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            // padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                task.title,
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Color.fromARGB(255, 19, 100, 240),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 19, 100, 240),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.more_vert,
                                  size: 16, color: Colors.grey),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(task.description),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                task.assignee,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 6),
                              if (task.highPriority)
                                Text(
                                  "High Priority",
                                  style: TextStyle(
                                    color: Colors.red[300],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            if (overdueText != null)
                              Text(
                                overdueText,
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              )
                            else if (!isCompleted && dueLabel.isNotEmpty)
                              Text(
                                dueLabel,
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            if (!isCompleted)
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_square,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                onPressed: () => _editStartDate(index),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                          ],
                        ),
                        if (isCompleted)
                          Text(
                            'Completed: ${_formatDate(task.startDate)}',
                            style: const TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        Text(
                            task.status == TaskStatus.notStarted
                                ? 'Start: ${_formatDate(task.startDate)}'
                                : 'Started: ${_formatDate(task.startDate)}',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  !isCompleted ? Colors.blue : Colors.black87,
                            )),
                        if (task.status == TaskStatus.notStarted)
                          TextButton.icon(
                            onPressed: () => _startTask(index),
                            icon: const Icon(Icons.play_circle, size: 16),
                            label: const Text(
                              'Start Task',
                              style: TextStyle(fontSize: 12),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.blue,
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 30),
                            ),
                          ),
                        if (task.status == TaskStatus.started)
                          TextButton.icon(
                            onPressed: () => _completeTask(index),
                            icon: const Icon(Icons.done, size: 16),
                            label: const Text(
                              'Mark as Complete',
                              style: TextStyle(fontSize: 12),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.green,
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 30),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
