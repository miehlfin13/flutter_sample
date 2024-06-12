import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mp2_tracker/modules/notifications/entity/notification_message.dart';
import 'package:mp2_tracker/modules/notifications/services/notification_service.dart';
import 'package:mp2_tracker/modules/security/services/security_service.dart';
import 'package:mp2_tracker/shared/tools/dialog_provider.dart';
import 'package:mp2_tracker/shared/tools/navigate.dart';
import 'package:mp2_tracker/shared/widgets/fields/standard_text_field.dart';
import 'package:mp2_tracker/shared/widgets/templates/standard_template.dart';

class PasswordSet extends StatefulWidget {
  const PasswordSet({super.key});

  @override
  State<StatefulWidget> createState() => _PasswordSetState();
}

class _PasswordSetState extends State<PasswordSet> {
  final service = SecurityService();
  final currentController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final service = SecurityService();
    final notificationService = NotificationService();
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    return StandardTemplate(
      title: 'Set Password',
      content: [
        StandardTextField(
          label: 'Current Password',
          icon: Icons.password,
          controller: currentController,
          inputFormatters: [LengthLimitingTextInputFormatter(50)],
          obscureText: true,
        ),
        StandardTextField(
          label: 'New Password',
          icon: Icons.password,
          controller: newController,
          inputFormatters: [LengthLimitingTextInputFormatter(50)],
          obscureText: true,
        ),
        StandardTextField(
          label: 'Confirm Password',
          icon: Icons.password,
          controller: confirmController,
          inputFormatters: [LengthLimitingTextInputFormatter(50)],
          obscureText: true,
        )
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (newController.text != confirmController.text) {
            DialogProvider.validationError(
              context: context,
              content: 'New password do not match.'
            );
          } else {
            Future.wait([service.validate(currentController.text)])
              .then((isValid) {
                if (!isValid.first) {
                  DialogProvider.validationError(
                    context: context,
                    content: 'Invalid password.'
                  );
                } else {
                  service.update(
                    newPassword: newController.text,
                    callback: () {
                      final task = newController.text.isEmpty ? 'Removed' : 'Updated';
                      
                      notificationService.createAndNotify(
                        context: context,
                        notification: NotificationMessage(
                          subject: 'Password $task',
                          content: 'Your password has been successfully ${task.toLowerCase()}.'
                        )
                      );

                      Navigate.toAccountList(context);
                    }
                  );
                }
              });
          }
        },
        tooltip: 'Save password',
        child: const Icon(Icons.save)
      )
    );
  }
}
