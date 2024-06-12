
import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/notifications/services/notification_service.dart';
import 'package:mp2_tracker/shared/constants/app.dart';
import 'package:mp2_tracker/shared/extensions/date_extension.dart';
import 'package:mp2_tracker/shared/tools/dialog_provider.dart';
import 'package:mp2_tracker/shared/tools/navigate.dart';
import 'package:mp2_tracker/shared/widgets/card_3d.dart';
import 'package:mp2_tracker/shared/widgets/label_value.dart';
import 'package:mp2_tracker/shared/widgets/templates/future_template.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final service = NotificationService();
  
  @override
  Widget build(BuildContext context) {
    const dateTimeFormat = 'yyyy MMMM dd HH:mm:ss';
    return FutureTemplate(
      title: 'Notifications',
      future: service.fetchAll(),
      hasCard: false,
      widgetBuild: (notifications) => [
        if (notifications.isNotEmpty)
          GestureDetector(
            onTap: () => DialogProvider.confirm(
              context: context,
              subject: 'Clear Confirmation',
              content: const Text('Are you sure you want to clear all notifications?'),
              defaultAction: () => service.deleteAll(
                callback: () => Navigate.toScreen(
                  context,
                  const NotificationList(),
                  callback: () => Navigate.toAccountList(context)
                )
              )
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.clear_all),
                Text('Clear all')
              ]
            )
          ),
        ...notifications.map((notification) {
          service.markAsRead(notificationId: notification.id);
          App.hasUnreadNotification = false;
          return Card3D(
            content: [
              Row(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Icon(
                    notification.isRead ? Icons.drafts : Icons.mail,
                    color: notification.isRead ? null : Colors.green.shade900
                  )
                ),
                Text(notification.subject, style: const TextStyle(fontWeight: FontWeight.bold)),
              ]),
              Text(notification.content),
              Text(notification.date!.format(dateTimeFormat), style: const TextStyle(fontSize: 10.0))
            ],
            stack: [
              Positioned(
                top: 5.0,
                right: 5.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Delete notification',
                      icon: const Icon(Icons.delete),
                      onPressed: () => DialogProvider.confirm(
                        context: context,
                        subject: 'Confirm Delete',
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Are you sure you want to delete this notification?'),
                            const Divider(),
                            LabelValue(
                              label: 'Subject',
                              value: notification.subject,
                              isAmount: false
                            ),
                            LabelValue(
                              label: 'DateTime',
                              value: notification.date!.format(dateTimeFormat),
                              isAmount: false
                            )
                          ]
                        ),
                        defaultAction: () => service.delete(
                          notificationId: notification.id,
                          callback: () => Navigate.toScreen(
                            context,
                            const NotificationList(),
                            callback: () => Navigate.toAccountList(context)
                          )
                        )
                      )
                    )
                  ]
                )
              )
            ]
          );
        })
      ]
    );
  }
}
