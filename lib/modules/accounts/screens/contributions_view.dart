import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/accounts/entity/account.dart';
import 'package:mp2_tracker/modules/accounts/screens/account_view.dart';
import 'package:mp2_tracker/modules/accounts/services/account_service.dart';
import 'package:mp2_tracker/modules/notifications/entity/notification_message.dart';
import 'package:mp2_tracker/modules/notifications/services/notification_service.dart';
import 'package:mp2_tracker/shared/extensions/date_extension.dart';
import 'package:mp2_tracker/shared/extensions/double_extension.dart';
import 'package:mp2_tracker/shared/tools/dialog_provider.dart';
import 'package:mp2_tracker/shared/tools/navigate.dart';
import 'package:mp2_tracker/shared/widgets/label_value.dart';
import 'package:mp2_tracker/shared/widgets/standard_table.dart';
import 'package:mp2_tracker/shared/widgets/templates/future_template.dart';

class ContributionsView extends StatefulWidget {
  const ContributionsView({
    super.key,
    required this.account,
    this.year,
    this.month
  });
  
  final Account account;
  final int? year;
  final int? month;

  @override
  State<StatefulWidget> createState() => _ContributionsViewState();
}

class _ContributionsViewState extends State<ContributionsView> {
  final service = AccountService();
  
  @override
  Widget build(BuildContext context) {
    TextStyle style = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    return FutureTemplate(
      title: 'Contributions',
      future: service.fetchAllContributions(widget.account.id, year: widget.year, month: widget.month),
      widgetBuild:(contributions) => [
        StandardTable(
          headers: const [
            'Date',
            'Amount',
            ''
          ],
          data: [
            ...contributions.map((contribution) => [
              Text(contribution.date.toDefaultFormat()),
              Text(contribution.amount.toFormatted()),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => DialogProvider.confirm(
                  context: context,
                  subject: 'Delete Confirmation',
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Are you sure you wanted to delete this contribution?'),
                      const Divider(),
                      LabelValue(
                        label: 'Date',
                        value: contribution.date.toDefaultFormat(),
                        isAmount: false
                      ),
                      LabelValue(
                        label: 'Amount',
                        value: contribution.amount.toString()
                      )
                    ]
                  ),
                  defaultAction: () {
                    service.deleteContribution(
                      contribution.id,
                      callback: () {
                        widget.account.contributions.removeWhere((item) => item.id == contribution.id);

                        NotificationService().createAndNotify(
                          context: context,
                          notification: NotificationMessage(
                            subject: 'Contribution Deleted',
                            content: 
                              'Your account (${widget.account.name}) contribution'
                              ' with an amount of ${contribution.amount.toFormatted()}'
                              ' on ${contribution.date.toDefaultFormat()}'
                              ' has been successfully deleted.'
                          )
                        );

                        Navigate.toScreen(
                          context,
                          AccountView(account: widget.account),
                          callback: () => Navigate.toAccountList(context)
                        );
                      }
                    );
                  }
                )
              )
            ]),
            [
              Text('Total', style: style),
              Text(
                (contributions.fold(0.0, (total, contribution) => total + contribution.amount)).toFormatted(),
                style: style
              ),
              const Text(' ')
            ]
          ]
        )
      ]
    );
  }
}
