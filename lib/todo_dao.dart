import 'package:floor/floor.dart';
import 'todo_item.dart';

@dao
abstract class ToDoDao {
  @Query('SELECT * FROM items ORDER BY id ASC')
  Future<List<ToDoItem>> findAll();

  // any single-row SELECT must be nullable:
  @Query('SELECT * FROM items WHERE id = :id')
  Future<ToDoItem?> findById(int id);

  @insert
  Future<int> insertItem(ToDoItem item);

  @update
  Future<int> updateItem(ToDoItem item);

  @delete
  Future<int> deleteItem(ToDoItem item);

  // ✅ change this to void (DELETE doesn’t need an int here)
  @Query('DELETE FROM items WHERE id = :id')
  Future<void> deleteById(int id);
}