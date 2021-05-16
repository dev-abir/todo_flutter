import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Todo.dart';

class DBProvider {
  // singleton class
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDb();
    return _database;
  }

  Future<Database> initDb() async {
    // TODO: is it necessary? WidgetsFlutterBinding.ensureInitialized();
    // TODO: give sql size limits, in db and ux as well....
    return await openDatabase(
      join(await getDatabasesPath(), 'todos.db'),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE todos("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "title TEXT,"
            "content TEXT"
            ")");
      },
      version: 1,
    );
  }

  Future<List<Todo>> getAllTodos() async {
    final db = await database;
    var res = await db.query("todos");
    List<Todo> list =
        res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> insertTodo(Todo todo) async {
    final db = await database;
    return await db.insert("todos", todo.toMap_DB());
  }

  Future<int> updateTodo(Todo updatedTodo) async {
    final db = await database;
    return await db.update("todos", updatedTodo.toMap_DB(),
        where: "id=?", whereArgs: [updatedTodo.ID]);
  }

  /*TODO: return type?*/
  Future deleteMultipleTodosWithID(List<int> IDs) async {
    final db = await database;
    Batch batch = db.batch();
    for (int ID in IDs) {
      db.delete("todos", where: "id=?", whereArgs: [ID]);
    }
    return await batch.commit(); // TODO: await batch.commit(noResult: true); is
    // faster, but it will ignore the results...
  }

  /*TODO: return type?*/
  insertMultipleTodos(List<Todo> todos) async {
    final db = await database;
    Batch batch = db.batch();
    for (Todo todo in todos) {
      batch.insert("todos", todo.toMap_DB());
    }
    return await batch.commit(); // TODO: await batch.commit(noResult: true); is
    // faster, but it will ignore the results...
  }
}
