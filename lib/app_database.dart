import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'todo_item.dart';
import 'todo_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [ToDoItem]) // 👈 entity included
abstract class AppDatabase extends FloorDatabase {
  ToDoDao get todoDao; // 👈 matches your DAO class name
}