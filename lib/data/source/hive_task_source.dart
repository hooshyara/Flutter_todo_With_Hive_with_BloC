import 'package:todo_list/data/data.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'source.dart';

class HiveTaskDataSource implements DataSource<Task> {
  final Box<Task> box;

  HiveTaskDataSource(this.box);

  @override
  Future<Task> createOrUpdate(Task data) async {
    if (data.isInBox) {
      data.save();
    } else {
      data.id = await box.add(data);
    }
    return data;
  }

  @override
  Future<void> delete(Task data) async {
    return data.delete();
  }

  @override
  Future<void> deleteAll() {
    return box.clear();
  }

  @override
  Future<void> deleteById(id) async {
    return box.delete(id);
  }

  @override
  Future<Task> findById(id) async {
    return box.values.firstWhere((element) => element.id == id);
  }

  @override
  Future<List<Task>> getAll({String searchKeyword = ''}) async {
    return box.values.toList();
  }
}
