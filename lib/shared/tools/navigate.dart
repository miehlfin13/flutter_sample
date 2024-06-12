import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/accounts/screens/account_list.dart';

class Navigate {
  static toScreen(BuildContext context, Widget screen, {void Function()? callback}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen)
    ).then((value) {
      if (callback != null) callback();
    });
  }

  static toAccountList(BuildContext context, {int? tabIndex}) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AccountList(tabIndex: tabIndex ?? 0)),
      (route) => false
    );
  }
}
