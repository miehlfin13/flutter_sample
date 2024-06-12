import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mp2_tracker/shared/constants/app.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalNotifications {
  static final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future initialize() async {
    _flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/launcher_icon')
      ),
      onDidReceiveNotificationResponse:(details) => {}
    );
  }

  static Future<void> notify({required String subject, required String content, String? payload}) async {
      PermissionStatus permission = await Permission.notification.request();
      if (permission.isGranted) {
        final androidNotificationDetails = AndroidNotificationDetails(
          App.notificationChannelId,
          App.notificationChannelName,
          channelDescription: App.notificationChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker'
        );

        await _flutterLocalNotificationsPlugin.show(
          0,
          subject,
          content,
          NotificationDetails(android: androidNotificationDetails),
          payload: payload
        );

        App.hasUnreadNotification = true;
      }
  }
}