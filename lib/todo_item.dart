import 'package:floor/floor.dart';

@Entity(tableName: 'items')
class ToDoItem {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;
  final int quantity;

  const ToDoItem({this.id, required this.name, required this.quantity});
}