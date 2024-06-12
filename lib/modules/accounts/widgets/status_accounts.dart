import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/accounts/enums/account_status.dart';
import 'package:mp2_tracker/modules/accounts/services/account_service.dart';
import 'package:mp2_tracker/modules/accounts/widgets/account_info.dart';
import 'package:mp2_tracker/modules/accounts/entity/account.dart';
import 'package:mp2_tracker/shared/widgets/standard_future_builder.dart';

class StatusAccounts extends StatefulWidget {
  const StatusAccounts({super.key, required this.status});

  final AccountStatus status;

  @override
  State<StatefulWidget> createState() => _StatusAccountsState();
}

class _StatusAccountsState extends State<StatusAccounts> {
  final service = AccountService();
  
  @override
  Widget build(BuildContext context) {
    return StandardFutureBuilder(
      future: fetchAccounts(),
      widgetBuild: (accounts) => accounts.isEmpty
        ? const Center(child: Text('No data'))
        : SingleChildScrollView(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(children: [ ...accounts.map((account) => AccountInfo(account: account)) ])
              )
            )
          )
    );
  }

  Future<List<Account>> fetchAccounts() async {
    var accounts = await service.fetchAllAccounts(widget.status);
    for (var i = 0; i < accounts.length; i++) {
      accounts[i].contributions = await service.fetchAllContributions(accounts[i].id);
    }
    return accounts;
  }
}