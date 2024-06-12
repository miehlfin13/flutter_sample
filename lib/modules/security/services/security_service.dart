import 'package:bcrypt/bcrypt.dart';
import 'package:mp2_tracker/shared/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class SecurityService {
  final tableName = 'security';

  Future<void> createTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        "password" TEXT NOT NULL
      )''');
  }

  Future<String?> fetch() async {
    final database = await DatabaseService().database;
    final security = await database.query(
      tableName
    );
    return security.firstOrNull?['password'] as String?;
  }

  Future<void> update({required String newPassword, void Function()? callback}) async {
    final database = await DatabaseService().database;
    final password = await fetch();

    if (newPassword.isNotEmpty) {
      newPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
    }

    if (password == null) {
      await database.rawInsert(
        'INSERT INTO $tableName (password) VALUES (?)',
        [newPassword]
      );
    } else {
      await database.rawUpdate(
        'UPDATE $tableName SET password = ?',
        [newPassword]
      );
    }

    if (callback != null) {
      callback();
    }
  }

  Future<bool> validate(String password) async {
    final currentPassword = await fetch();

    if (currentPassword == null || currentPassword.isEmpty) {
      return password.isEmpty;
    }

    return BCrypt.checkpw(password, currentPassword);
  }
}