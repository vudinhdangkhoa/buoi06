import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:buoi06/model/chitieu.dart';
import 'package:buoi06/model/account.dart';

class DB_bai5 {
  static final DB_bai5 _instance = DB_bai5._internal();
  factory DB_bai5() {
    return _instance;
  }
  DB_bai5._internal();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    return await _initDB();
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'app_qltk.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
      CREATE TABLE account(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT NOT NULL,
      password TEXT NOT NULL
    )
  ''');
      },
    );
  }

  Future<int> insertAccount(Account acc) async {
    final db = await database;
    return await db.insert(
      'account',
      acc.ToMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Account>> getAccount() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('account');
    List<Account> lstacc = [];
    for (var item in maps) {
      lstacc.add(Account.fromMap(item));
    }
    return lstacc;
  }

  Future<bool> checkLogin(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'account',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return maps.isNotEmpty;
  }
}
