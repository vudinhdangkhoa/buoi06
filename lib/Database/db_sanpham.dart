import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:buoi06/model/sanpham.dart';

class DBSanPham {
  static final DBSanPham _instance = DBSanPham._internal();
  static Database? _database;

  factory DBSanPham() {
    return _instance;
  }

  DBSanPham._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'app_qlsp.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(''' 
          CREATE TABLE sanpham( 
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            name TEXT NOT NULL, 
            price REAL NOT NULL,
            sale REAL NOT NULL
          ) 
        ''');
      },
    );
  }

  Future<int> insertSanPham(Sanpham sp) async {
    final db = await database;
    return await db.insert(
      'sanpham',
      sp.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Sanpham>> getSanPham() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sanpham');

    return List.generate(maps.length, (i) {
      return Sanpham(
        id: maps[i]['id'],
        name: maps[i]['name'],
        price: maps[i]['price'],
        sale: maps[i]['sale'],
      );
    });
  }

  Future<int> updateSanPham(Sanpham sp) async {
    final db = await database;
    return await db.update(
      'sanpham',
      sp.toMap(),
      where: "id =?",
      whereArgs: [sp.id],
    );
  }

  Future<int> deleteSanPham(int id) async {
    final db = await database;
    return await db.delete('sanpham', where: 'id=?', whereArgs: [id]);
  }
}
