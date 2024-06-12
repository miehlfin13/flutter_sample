import 'package:mp2_tracker/modules/dividends/entity/dividend.dart';
import 'package:mp2_tracker/shared/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class DividendService {
  final tableName = 'dividends';

  Future<void> createTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        "id" INTEGER NOT NULL,
        "year" INTEGER NOT NULL,
        "rate" REAL NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT)
      )''');
  }

  Future<int> create({required Dividend dividend}) async {
    final database = await DatabaseService().database;
    return await database.insert(
      tableName,
      dividend.toSqflite(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }
  
  Future<List<Dividend>> fetchAll([int? startYear]) async {
    final database = await DatabaseService().database;
    final dividends = await database.query(
      tableName,
      where: startYear == null ? null : 'year >= ?',
      whereArgs: startYear == null ? null : [startYear],
      orderBy: 'year DESC'
    );
    return dividends.map((dividend) => Dividend.fromSqflite(dividend)).toList();
  }
}
