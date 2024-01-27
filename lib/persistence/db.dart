import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;


class DatabaseOperations {

  static DatabaseOperations? _databaseOperations;
  Database? _database;
  Database? get database => _database;

  DatabaseOperations._internal();

  static DatabaseOperations? get instance {
    _databaseOperations ??= DatabaseOperations._internal();
    return _databaseOperations;
  }

  Future<void> openDb() async {
    _database ??= await openDatabase(
        p.join(await getDatabasesPath(), 'goods_meal_database.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE IF NOT EXISTS goods_meal(value REAL PRIMARY KEY, qty INTEGER)',
          );
        },
        version: 1,
      );
  }

}