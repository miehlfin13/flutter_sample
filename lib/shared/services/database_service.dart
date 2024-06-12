import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:mp2_tracker/modules/accounts/services/account_service.dart';
import 'package:mp2_tracker/modules/dividends/services/dividend_service.dart';
import 'package:mp2_tracker/modules/notifications/services/notification_service.dart';
import 'package:mp2_tracker/modules/security/services/security_service.dart';
import 'package:mp2_tracker/shared/constants/app.dart';
import 'package:mp2_tracker/shared/extensions/date_extension.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }
  
  Future<String> get fullPath async {
    final path = await getDatabasesPath();
    return join(path, App.databaseName);
  }
  
  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: App.databaseVersion,
      onCreate: create,
      singleInstance: true
    );
    return database;
  }

  Future<void> delete() async {
    final path = await fullPath;
    await deleteDatabase(path);
  }

  Future<String> backup() async {
    try {
      await Directory(App.backupPath).create(recursive: true);
      final path = await fullPath;
      final fileName = 'backup_${DateTime.now().format('yyyyMMddHHmmss')}.mp2tr';
      final backupFile = '${App.backupPath}/$fileName';
      await File(path).copy(backupFile);
      return backupFile;
    } catch (e) {
      return '';
    }
  }

  Future<String> restore() async {
    final path = await fullPath;
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final filePath = result.files.single.path;
      if (filePath != null) {
        File(filePath).copy(path);
        return filePath;
      }
    }
    return '';
  }
  
  Future<void> create(Database database, int version) async {
    App.isNewDatabase = true;
    await NotificationService().createTable(database);
    await DividendService().createTable(database);
    await SecurityService().createTable(database);
    await AccountService().createTable(database);
  }
}
