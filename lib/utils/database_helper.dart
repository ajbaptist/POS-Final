// lib/database_manager.dart
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:thermal_printer_example/model/data_model.dart';
import 'package:thermal_printer_example/model/history_model.dart';
import 'package:thermal_printer_example/utils/db_constant.dart';

class DatabaseManager {
  late Database _database;

  // Singleton instance
  static final DatabaseManager _singleton = DatabaseManager._internal();

  // Private constructor
  DatabaseManager._internal();

  // Getter for the singleton instance
  static DatabaseManager get instance {
    return _singleton;
  }

  // Initialize the database and create tables

  // Open the database
  Future<void> openDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DbConstants.databaseName);
    _database = sqlite3.open(path);
  }

  // Close the database
  void closeDatabase() {
    _database.dispose();
  }

  // Create the table if not exists
  void createTable(String tableName) {
    _database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        name TEXT,
        date INTEGER,
        month INTEGER,
        year INTEGER
      )
    ''');
  }

  // Create the table if not exists
  void createPrintTable(String tableName) {
    _database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        date TEXT,
        printer TEXT
      )
    ''');
  }

  // Insert data into the specified table using a DataModel
  void insertData(DataModel dataModel) {
    createTable(DbConstants.tableName); // Ensure the table exists
    _database.execute('''
      INSERT INTO ${DbConstants.tableName} (name, date, month, year)
      VALUES (?, ?, ?, ?)
    ''', [dataModel.name, dataModel.date, dataModel.month, dataModel.year]);
  }

  // Insert data into the specified table using a DataModel
  void insertHistoryData(HistroyModel dataModel) {
    createPrintTable(DbConstants.histroyTableName); // Ensure the table exists
    _database.execute('''
      INSERT INTO ${DbConstants.histroyTableName} (name, date, month, year)
      VALUES (?, ?, ?, ?)
    ''', [dataModel.name.toIso8601String(), dataModel.printerName]);
  }

  // Retrieve data from the specified table
  List<DataModel> fetchData() {
    try {
      final res = _database.select('SELECT * FROM ${DbConstants.tableName}');

      return res.map((data) => DataModel.fromJson(data)).toList();
    } catch (e) {
      log('er---->$e');
      return [];
    }
  }

  // Retrieve data from the specified table
  List<HistroyModel> fetcHistoryData() {
    try {
      final res =
          _database.select('SELECT * FROM ${DbConstants.histroyTableName}');

      return res.map((data) => HistroyModel.fromJson(data)).toList();
    } catch (e) {
      return [];
    }
  }
}
