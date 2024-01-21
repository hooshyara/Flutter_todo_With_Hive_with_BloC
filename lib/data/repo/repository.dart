import 'package:flutter/cupertino.dart';

import '../source/source.dart';

class Repository<T> extends ChangeNotifier implements DataSource<T>{
  final DataSource<T> localDataSource;
  Repository(this.localDataSource);
  @override
  Future<T> createOrUpdate(T data) async{
    final T result = await localDataSource.createOrUpdate(data);
    notifyListeners();
    return result;
  }

  @override
  Future<void> delete(T data) async{
    notifyListeners();

    return localDataSource.delete(data);
  }

  @override
  Future<void> deleteAll() async{
    notifyListeners();
    return localDataSource.deleteAll();
  }

  @override
  Future<void> deleteById(id) {
    return localDataSource.deleteById(id);
  }

  @override
  Future<T> findById(id) {
    return localDataSource.findById(id);
  }

  @override
  Future<List<T>> getAll({String searchKeyword=''}){
    return localDataSource.getAll(searchKeyword: searchKeyword);
  }

}