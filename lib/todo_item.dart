import 'package:floor/floor.dart';

@entity
class TodoItem {
  @primaryKey // (use lowercase for best compatibility)
  final int? id;        // null on insert; Floor will generate it
  final String name;
  final int quantity;

  const TodoItem({this.id, required this.name, required this.quantity});
}