import 'package:mp2_tracker/modules/notifications/entity/notification_message.dart';
import 'package:mp2_tracker/modules/notifications/services/notification_service.dart';

class NotificationDataProvider {
  static Future<void> initializeTestData() async {
    final service = NotificationService();

    await service.create(NotificationMessage(
      date: DateTime.parse('2024-02-25 13:45:02'),
      subject: 'Test Notification',
      content: 'This is a test notification',
      isRead: true
    ));
    
    await service.create(NotificationMessage(
      date: DateTime.parse('2024-02-26'),
      subject: 'Account Maturity',
      content: 'The account Test Account has matured. You can now claim your savings via Virtual Pag-Ibig or by going to the nearest branch.'
    ));
  }
}
