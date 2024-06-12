import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/notifications/entity/notification_message.dart';
import 'package:mp2_tracker/modules/notifications/services/notification_service.dart';
import 'package:mp2_tracker/shared/services/database_service.dart';
import 'package:mp2_tracker/shared/tools/navigate.dart';
import 'package:mp2_tracker/shared/widgets/button.dart';
import 'package:mp2_tracker/shared/widgets/templates/standard_template.dart';

class ImportExport extends StatefulWidget {
  const ImportExport({super.key});

  @override
  State<StatefulWidget> createState() => _ImportExportState();
}

class _ImportExportState extends State<ImportExport> {
  final service = DatabaseService();
  final notificationService = NotificationService();
  
  @override
  Widget build(BuildContext context) {
    return StandardTemplate(
      title: 'Import / Export',
      hasCard: false,
      content: [
        Button(
          label: 'Export Data',
          icon: Icons.upload,
          onTap: () {
            Future.wait([service.backup()])
              .then((value) {
                String fileName = value.first;
                if (fileName.isNotEmpty) {
                  notificationService.createAndNotify(
                    context: context,
                    notification: NotificationMessage(
                      subject: 'Export',
                      content: 'Your data has been successfully exported ($fileName).'
                    )
                  );
                }
              });
          }
        ),
        Button(
          label: 'Import Data',
          icon: Icons.download,
          onTap: () {
            Future.wait([service.restore()])
              .then((value) {
                String fileName = value.first;
                if (fileName.isNotEmpty) {
                  notificationService.createAndNotify(
                    context: context,
                    notification: NotificationMessage(
                      subject: 'Import',
                      content: 'Your data has been successfully imported ($fileName).'
                    )
                  );

                  Navigate.toAccountList(context);
                }
              });
          }
        )
      ]
    );
  }
}
