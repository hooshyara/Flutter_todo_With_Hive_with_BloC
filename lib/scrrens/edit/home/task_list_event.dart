part of 'task_list_bloc.dart';

@immutable
abstract class TaskListEvent {}


class TaskListStared extends TaskListEvent{}


class TaskListSearch extends TaskListEvent{
  final String searchTerm;
  TaskListSearch(this.searchTerm);
}

class TaskListDeleteAll extends TaskListEvent{}

