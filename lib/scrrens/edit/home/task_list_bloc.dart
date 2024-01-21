import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/data.dart';
import '../../../data/repo/repository.dart';

part 'task_list_event.dart';

part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final Repository<Task> repository;

  TaskListBloc(this.repository) : super(TaskListInitial()) {
    on<TaskListEvent>((event, emit) async {
      if (event is TaskListStared || event is TaskListSearch){
        String searchTerm;
        emit(TaskListLoading());
        await Future.delayed(Duration(seconds: 1));
        if (event is TaskListSearch) {
          searchTerm = event.searchTerm;
        } else {
          searchTerm = '';
        }
        try {
          final items = await repository.getAll(searchKeyword: searchTerm);
          if (items.isNotEmpty) {
            emit(TaskListSuccess(items));
          } else {
            emit(TaskListEmpty());
          }
        } catch (e) {
          emit(TaskListError('خطای نامشحص'));
        }
      }else if(event is TaskListDeleteAll){
        await repository.deleteAll();
        emit(TaskListEmpty());
      }
    });
  }
}
