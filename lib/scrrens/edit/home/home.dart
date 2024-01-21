import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/scrrens/edit/home/task_list_bloc.dart';
import '../../../data/data.dart';
import '../../../main.dart';
import '../../../widgets.dart';
import '../edit.dart';
import 'package:provider/provider.dart';
import '../../../data/repo/repository.dart';

const taskBoxName = 'tasks';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Task>(taskBoxName);

    final themData = Theme.of(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('To Do List'),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => EditTaskScreen(
                task: Task(),
              ),
            ),
          );
        },
        label: Row(
          children: [
            Text('Add a New Task'),
            const SizedBox(
              width: 8,
            ),
            Icon(CupertinoIcons.add)
          ],
        ),
      ),
      body: BlocProvider<TaskListBloc>(
        create: (context) => TaskListBloc(context.read<Repository<Task>>()),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 110,
                decoration: BoxDecoration(
                  color: themData.colorScheme.primaryContainer,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'To Do List',
                            style: themData.textTheme.headline6!.apply(
                              color: themData.colorScheme.onPrimary,
                            ),
                          ),
                          Icon(
                            CupertinoIcons.share,
                            color: themData.colorScheme.onPrimary,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        height: 38,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(19),
                            color: themData.colorScheme.onPrimary,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                              ),
                            ]),
                        child: TextField(
                          onChanged: (value) {
                            context.read<TaskListBloc>().add(TaskListSearch(value));
                          },
                          controller: controller,
                          decoration: InputDecoration(
                            prefixIcon: Icon(CupertinoIcons.search),
                            label: Text('Search tasks  ...'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: Consumer<Repository<Task>>(

                builder:(context, value, child) {
                  context.read<TaskListBloc>().add(TaskListStared());
                  return BlocBuilder<TaskListBloc, TaskListState>(
                    builder: (context, state) {
                      if (state is TaskListSuccess) {
                        return TaskList(
                            items: state.items, themData: themData, box: box);
                      } else if (state is TaskListEmpty) {
                        return EmptyState();
                      } else if (state is TaskListLoading ||
                          state is TaskListInitial) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is TaskListError) {
                        return Center(
                          child: Text(state.errorMessage),
                        );
                      } else {
                        throw Exception('state is not valid..');
                      }
                    },
                  );
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.items,
    required this.themData,
    required this.box,
  });

  final items;
  final ThemeData themData;
  final Box<Task> box;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today',
                    style: themData.textTheme.headline6!
                        .apply(fontSizeFactor: 0.9),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 3,
                    width: 70,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: themData.colorScheme.primary,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                ],
              ),
              MaterialButton(
                color: Color(0xffEAEFF5),
                textColor: secondaryTextColor,
                onPressed: () {
                  context.read<TaskListBloc>().add(TaskListDeleteAll());

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('All task is Deleted'),
                    ),
                  );
                },
                elevation: 0,
                child: Row(
                  children: [
                    Text(
                      'Delete All',
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Icon(
                      CupertinoIcons.delete_solid,
                      size: 18,
                    ),
                  ],
                ),
              )
            ],
          );
        } else {
          final Task task = items[index - 1];
          return TaskItem(task: task);
        }
      },
    );
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final priorityColor;
    switch (widget.task.priority) {
      case Priority.normal:
        priorityColor = normalPriority;
        break;
      case Priority.low:
        priorityColor = lowPriority;
        break;
      case Priority.high:
        priorityColor = highPriority;
        break;
    }
    return InkWell(
      onTap: () {
        setState(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditTaskScreen(
                task: widget.task,
              ),
            ),
          );
        });
      },
      onLongPress: () {
        widget.task.delete();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Task ${widget.task.name} is Deleted'),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 84,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: themeData.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(0.2),
                ),
              ]),
          child: Row(
            children: [
              MyCheckBox(
                value: widget.task.isCompleted,
                onTap: () {
                  setState(() {
                    widget.task.isCompleted = !widget.task.isCompleted;
                  });
                },
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  widget.task.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
              Container(
                width: 4,
                height: 90,
                decoration: BoxDecoration(
                    color: priorityColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
