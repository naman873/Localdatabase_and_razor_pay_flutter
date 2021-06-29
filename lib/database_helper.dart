import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static final _dbName = 'myDatabase.db';
  static final _version = 1;
  static final _tableName = 'myTable';
  static final columnId = '_id';
  static final columnName = 'name';

  //making a singleton class
  DataBaseHelper._privateConstructor();
  static final DataBaseHelper instance = DataBaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async =>
      _database ??= await _initializeDatabase();

  Future<Database> _initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _version, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) {
    return db.execute(
        ''' CREATE TABLE $_tableName ($columnId INTEGER PRIMARY KEY , $columnName TEXT NOT NULL) ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db =
        await instance.database; // instance.database call get database function

    return await db.insert(_tableName, row);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return db.update(_tableName, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    // Directory directory = await getApplicationDocumentsDirectory();
    // print(directory.path);
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return db.delete(_tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  // No truncate in sqlfite
  // Future<void> truncate() async {
  //   Database db = await instance.database;
  //   return db.execute('TRUNCATE  TABLE $_tableName');
  // }
}
