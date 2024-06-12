import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mp2_tracker/modules/notifications/entity/notification_message.dart';
import 'package:mp2_tracker/modules/notifications/services/local_notification_service.dart';
import 'package:mp2_tracker/shared/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class NotificationService {
  final tableName = 'notifications';

  Future<void> createTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        "id" INTEGER NOT NULL,
        "date" INTEGER NOT NULL,
        "subject" TEXT NOT NULL,
        "content" TEXT NOT NULL,
        "isRead" INTEGER NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT)
      )''');
  }
  
  Future<int> create(NotificationMessage notification) async {
    final database = await DatabaseService().database;
    return await database.insert(
      tableName,
      notification.toSqflite(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<int> createAndNotify({
    required BuildContext context,
    required NotificationMessage notification
  }) async {
    int id = await create(notification);

    if (!context.mounted) return id;
    await notify(context: context, notification: notification);

    return id;
  }

  Future<List<NotificationMessage>> fetchAll() async {
    final database = await DatabaseService().database;
    final notifications = await database.query(
      tableName,
      orderBy: 'id DESC'
    );
    return notifications.map((notification) => NotificationMessage.fromSqflite(notification)).toList();
  }

  Future<void> markAsRead({required int notificationId, void Function()? callback}) async {
    final database = await DatabaseService().database;
    await database.rawUpdate(
      'UPDATE $tableName SET isRead = 1 WHERE id = ?',
      [notificationId]
    );
  }

  Future<void> delete({required int notificationId, void Function()? callback}) async {
    final database = await DatabaseService().database;
    await database.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [notificationId]
    );
    
    if (callback != null) {
      callback();
    }
  }

  Future<void> deleteAll({void Function()? callback}) async {
    final database = await DatabaseService().database;
    await database.delete(tableName);
    
    if (callback != null) {
      callback();
    }
  }

  Future<void> notify({
    required BuildContext context,
    required NotificationMessage notification
  }) async {
    await LocalNotifications.notify(subject: notification.subject, content: notification.content);

    /* TODO: dialog notify if notification permission is denied
    DialogProvider.info(
      context: context,
      subject: notification.subject,
      content: Text(notification.content)
    );*/
  }
}
