// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ToDoDao? _todoDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `items` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `quantity` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ToDoDao get todoDao {
    return _todoDaoInstance ??= _$ToDoDao(database, changeListener);
  }
}

class _$ToDoDao extends ToDoDao {
  _$ToDoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _toDoItemInsertionAdapter = InsertionAdapter(
            database,
            'items',
            (ToDoItem item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'quantity': item.quantity
                }),
        _toDoItemUpdateAdapter = UpdateAdapter(
            database,
            'items',
            ['id'],
            (ToDoItem item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'quantity': item.quantity
                }),
        _toDoItemDeletionAdapter = DeletionAdapter(
            database,
            'items',
            ['id'],
            (ToDoItem item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'quantity': item.quantity
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ToDoItem> _toDoItemInsertionAdapter;

  final UpdateAdapter<ToDoItem> _toDoItemUpdateAdapter;

  final DeletionAdapter<ToDoItem> _toDoItemDeletionAdapter;

  @override
  Future<List<ToDoItem>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM items ORDER BY id ASC',
        mapper: (Map<String, Object?> row) => ToDoItem(
            id: row['id'] as int?,
            name: row['name'] as String,
            quantity: row['quantity'] as int));
  }

  @override
  Future<ToDoItem?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM items WHERE id = ?1',
        mapper: (Map<String, Object?> row) => ToDoItem(
            id: row['id'] as int?,
            name: row['name'] as String,
            quantity: row['quantity'] as int),
        arguments: [id]);
  }

  @override
  Future<void> deleteById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM items WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<int> insertItem(ToDoItem item) {
    return _toDoItemInsertionAdapter.insertAndReturnId(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateItem(ToDoItem item) {
    return _toDoItemUpdateAdapter.updateAndReturnChangedRows(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteItem(ToDoItem item) {
    return _toDoItemDeletionAdapter.deleteAndReturnChangedRows(item);
  }
}
