import 'package:floor/floor.dart';

@entity
class TodoItem {
  @primaryKey // <= use lowercase; most compatible
  final int? id;        // null on insert; Floor auto-generates
  final String name;
  final int quantity;

  const TodoItem({this.id, required this.name, required this.quantity});
}