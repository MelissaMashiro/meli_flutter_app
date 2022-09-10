import 'package:meli_flutter_app/src/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String usersTable = 'users';

class SqfliteDatabase {
//singleton
  SqfliteDatabase._privateConstructor();
  static final SqfliteDatabase instance = SqfliteDatabase._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    return await _init();
  }

  Future<void> _onCreate(Database db, int ver) async {
    await db.execute(
      //  "CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, lastname TEXT,age INTEGER, email TEXT)",
      '''
   CREATE TABLE users(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    lastname TEXT,
    age INTEGER,
    email TEXT
    )
    ''',
    );
  }

  Future<Database> _init() async {
    print('iniciando database--->');
    return await openDatabase(
      join(await getDatabasesPath(), 'users.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<List<User>> readUsers() async {
    print('leyendo usuarios--->');
    var db = await instance.database; //reference to the database unic instance
    var users = await db.query(usersTable, orderBy: 'id');
    // ignore: omit_local_variable_types
    List<User> usersList =
        users.isNotEmpty ? users.map((e) => User.fromJson(e)).toList() : [];
    print('lista de usuarios---> $usersList');

    return usersList;
  }

  Future<User> readSingleUser(int userId) async {
    var db = await instance.database; //reference to the database unic instance
    var users = await db.query(
      usersTable,
      where: 'id=?',
      whereArgs: [userId],
    );
    // ignore: omit_local_variable_types
    List<User> usersList =
        users.isNotEmpty ? users.map((e) => User.fromJson(e)).toList() : [];
    print('usuario encontrado ---> ${usersList.first}');

    return usersList.first;
  }

  Future<int> addUser(User user) async {
    var db = await instance.database;
    print('creando nuevo usuario --->');
    //    await db.rawInsert('INSERT INTO $table ($columnName, $columnAge) VALUES("Bob", 23)');

    return await db.insert(usersTable, user.toJson());
  }

  Future<void> removeUser(int userId) async {
    var db = await instance.database;
    await db.delete(
      usersTable,
      where: 'id=?',
      whereArgs: [userId],
    );
    print('usuario removido --->');
  }

  Future<int> update(User user) async {
    var db = await instance.database;
    print('actualizando usuario --->');

    return await db.update(
      usersTable,
      user.toJson(),
      where: 'id=?',
      whereArgs: [user.id],
    );
  }
}

class SQLiteHelper {
  Future<List<Map<String, dynamic>>> get Users async {
    return await SqfliteDatabase._database!.query(
      usersTable,
      orderBy: 'id DESC',
    );
  }
}
