import 'package:floor/floor.dart';
import 'todo_item.dart';

@dao
abstract class TodoDao {
  @Query('SELECT * FROM TodoItem')
  Future<List<TodoItem>> getAll();

  @insert
  Future<int> insertOne(TodoItem item);

  @delete
  Future<int> deleteOne(TodoItem item);
}