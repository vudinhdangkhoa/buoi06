import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:buoi06/model/chitieu.dart';
import 'package:buoi06/model/account.dart';

class DB_bai4 {
  static final DB_bai4 _instance = DB_bai4._internal();
  factory DB_bai4() {
    return _instance;
  }
  DB_bai4._internal();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    return await _initDB();
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'app_qlct.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
    CREATE TABLE chitieu(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      titel TEXT NOT NULL,
      price REAL NOT NULL,
      note TEXT NOT NULL
    )
  ''');
      },
    );
  }

  Future<int> insertChiTieu(ChiTieu ct) async {
    final db = await database;
    return await db.insert(
      'chitieu',
      ct.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ChiTieu>> getChiTieu() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('chitieu');
    List<ChiTieu> lstct = [];
    for (var item in maps) {
      lstct.add(ChiTieu.fromMap(item));
    }
    return lstct;
  }

  Future<void> deleteDatabaseFile() async {
    String path = join(await getDatabasesPath(), 'app_qlct.db');
    await deleteDatabase(path);
    print("Cơ sở dữ liệu đã được xóa");
  }

  Future<int> updateChiTieu(ChiTieu ct) async {
    final db = database;
    return await db.then((value) {
      return value.update(
        'chitieu',
        ct.toMap(),
        where: "id = ?",
        whereArgs: [ct.id],
      );
    });
  }

  Future<int> deleteChiTieu(int id) async {
    final db = await database;
    return await db.delete('chitieu', where: 'id=?', whereArgs: [id]);
  }

  Future<void> debugTables() async {
    final db = await database;
    final List<Map<String, dynamic>> tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table'",
    );
    print("Các bảng trong cơ sở dữ liệu: $tables");
  }
}
