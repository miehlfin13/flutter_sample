import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mp2_tracker/modules/security/services/security_service.dart';
import 'package:mp2_tracker/shared/constants/app.dart';
import 'package:mp2_tracker/shared/tools/dialog_provider.dart';
import 'package:mp2_tracker/shared/tools/navigate.dart';
import 'package:mp2_tracker/shared/widgets/fields/standard_text_field.dart';

class PasswordEntry extends StatefulWidget {
  const PasswordEntry({super.key});

  @override
  State<StatefulWidget> createState() => _PasswordEntryState();
}

class _PasswordEntryState extends State<PasswordEntry> {
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue.shade200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 128.0, width: 128.0),
            Text('Version: ${App.version}'),
            const Text(
              '\nWelcome to MP2 Tracker!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20
              )
            ),
            StandardTextField(
              label: 'Enter Password',
              icon: Icons.password,
              controller: passwordController,
              inputFormatters: [LengthLimitingTextInputFormatter(50)],
              obscureText: true
            )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Future.wait([SecurityService().validate(passwordController.text)])
            .then((isValid) {
              if (!isValid.first) {
                DialogProvider.validationError(
                  context: context,
                  content: 'Invalid password.'
                );
              }
              else {
                Navigate.toAccountList(context);
              }
            });
        },
        tooltip: 'Login',
        child: const Icon(Icons.login)
      )
    );
  }
}
