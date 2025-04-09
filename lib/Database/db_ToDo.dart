import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:buoi06/model/congviec.dart';

class DbTodo {
  static final DbTodo _instance = DbTodo._internal();
  static Database? _database;

  factory DbTodo() {
    return _instance;
  }

  DbTodo._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'app_qlcv.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(''' 
          CREATE TABLE congviec( 
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            name TEXT NOT NULL, 
            content TEXT NOT NULL,
            status TEXT NOT NULL
          ) 
        ''');
      },
    );
  }

  Future<int> insertCongViec(CongViec cv) async {
    final db = await database;
    return await db.insert(
      'congviec',
      cv.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CongViec>> getCongViecs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('congviec');

    return List.generate(maps.length, (i) {
      return CongViec(
        id: maps[i]['id'],
        tenCV: maps[i]['name'],
        moTa: maps[i]['content'],
        trangthai: maps[i]['status'],
      );
    });
  }

  Future<int> updateCongViec(CongViec cv) async {
    final db = await database;
    return await db.update(
      'congviec',
      cv.toMap(),
      where: 'id = ?',
      whereArgs: [cv.id],
    );
  }

  Future<int> deleteCongViec(int id) async {
    final db = await database;
    return await db.delete('congviec', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllCongViec() async {
    final db = await database;
    return await db.delete('congviec');
  }
}
