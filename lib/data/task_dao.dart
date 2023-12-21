import 'package:first_project/components/task.dart';
import 'package:first_project/data/database.dart';
import 'package:sqflite/sqflite.dart';

class TaskDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_name TEXT, '
      '$_difficulty INTEGER, '
      '$_image TEXT)';

  static const String _tableName = 'taskTable';
  static const String _name = 'nome';
  static const String _image = 'image';
  static const String _difficulty = 'difficulty';
  static const String _level = 'level';

  save(Task task) async {
    final Database database = await getDatabase();
    var itemExists = await find(task.nome);
    Map<String, dynamic> taskMap = toMap(task);
    if (itemExists.isEmpty) {
      return await database.insert(_tableName, taskMap);
    } else {
      return await database.update(_tableName, taskMap,
          where: '$_name = ?', whereArgs: [task.nome]);
    }
  }

  Map<String, dynamic> toMap(Task task) {
    final Map<String, dynamic> taskMap = Map();
    taskMap[_name] = task.nome;
    taskMap[_difficulty] = task.dificuldade;
    taskMap[_image] = task.foto;
    taskMap[_level] = task.nivel;
    return taskMap;
  }

  Future<List<Task>> findAll() async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> result = await database.query(_tableName);
    return toList(result);
  }

  List<Task> toList(List<Map<String, dynamic>> taskList) {
    final List<Task> tasks = [];
    for (Map<String, dynamic> row in taskList) {
      final Task task = Task(row[_name], row[_image], row[_difficulty]);
      tasks.add(task);
    }
    return tasks;
  }

  Future<List<Task>> find(String taskName) async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> result = await database
        .query(_tableName, where: '$_name = ?', whereArgs: [taskName]);
    return toList(result);
  }

  delete(String taskName) async {
    final Database database = await getDatabase();
    return database
        .delete(_tableName, where: '$_name = ?', whereArgs: [taskName]);
  }
}
