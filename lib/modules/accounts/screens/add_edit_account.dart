import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mp2_tracker/modules/accounts/entity/account.dart';
import 'package:mp2_tracker/modules/accounts/services/account_service.dart';
import 'package:mp2_tracker/modules/notifications/entity/notification_message.dart';
import 'package:mp2_tracker/modules/notifications/services/notification_service.dart';
import 'package:mp2_tracker/shared/extensions/date_extension.dart';
import 'package:mp2_tracker/shared/extensions/double_extension.dart';
import 'package:mp2_tracker/shared/extensions/icon_data_extension.dart';
import 'package:mp2_tracker/shared/tools/dialog_provider.dart';
import 'package:mp2_tracker/shared/tools/navigate.dart';
import 'package:mp2_tracker/shared/widgets/fields/amount_field.dart';
import 'package:mp2_tracker/shared/widgets/fields/date_field.dart';
import 'package:mp2_tracker/shared/widgets/fields/icon_field.dart';
import 'package:mp2_tracker/shared/widgets/fields/number_field.dart';
import 'package:mp2_tracker/shared/widgets/fields/standard_dropdown_field.dart';
import 'package:mp2_tracker/shared/widgets/fields/standard_text_field.dart';
import 'package:mp2_tracker/shared/widgets/label_value.dart';
import 'package:mp2_tracker/shared/widgets/templates/standard_template.dart';

class AddEditAccount extends StatefulWidget {
  const AddEditAccount({
    super.key,
    this.account
  });

  final Account? account;
  
  @override
  State<StatefulWidget> createState() => _AddEditAccountState();
}

class _AddEditAccountState extends State<AddEditAccount> {
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  bool isYearlyPayout = false;
  final startDateController = TextEditingController();
  String startDateValue = '';
  final targetAmountController = TextEditingController();
  IconData icon = Icons.attach_money;

  bool isNew = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      isNew = widget.account == null;
    });

    if (!isNew) {
      setState(() {
        nameController.text = widget.account!.name;
        numberController.text = widget.account!.number;
        startDateController.text = widget.account!.startDate.toDefaultFormat();
        startDateValue = widget.account!.startDate.format('yyyy-MM-dd');
        targetAmountController.text = widget.account!.targetAmount.toFormatted().replaceAll(',', '');
        isYearlyPayout = widget.account!.isYearlyPayout;
        icon = widget.account!.icon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = isNew ? 'Add New Account' : 'Edit Account';
    
    return StandardTemplate(
      title: title,
      content: [
        StandardTextField(
          label: 'Account Name',
          controller: nameController,
          inputFormatters: [LengthLimitingTextInputFormatter(50)]
        ),
        NumberField(
          label: 'Account Number',
          controller: numberController
        ),
        StandardDropDownField(
          label: 'Payout Type',
          icon: Icons.attach_money,
          items: const [
            DropdownMenuItem(value: 0, child: Text('Maturity')),
            DropdownMenuItem(value: 1, child: Text('Yearly')),
          ],
          value: isNew ? null : (isYearlyPayout ? 1 : 0),
          onChanged: (value) {
            setState(() {
              isYearlyPayout = (value ?? 0) == 0 ? false : true; 
            });
          }
        ),
        DateField(
          context: context,
          label: 'Start Date',
          icon: Icons.today,
          controller: startDateController,
          onSelect: (value) => {
            setState(() {
              startDateController.text = value.toDefaultFormat();
              startDateValue = value.format('yyyy-MM-dd');
            })
          },
          onCancel: () => {
            setState(() {
              startDateController.text = '';
              startDateValue = '';
            })
          }
        ),
        AmountField(
          label: 'Target Amount',
          icon: Icons.my_location,
          controller: targetAmountController
        ),
        IconField(
          value: icon.codePoint,
          onChanged: (iconCodePoint) => {
            setState(() {
              icon = IconData(iconCodePoint, fontFamily: 'MaterialIcons');
            })
          }
        )
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final startDate = DateTime.tryParse(startDateValue);

          if (nameController.text.isEmpty) {
            DialogProvider.validationError(
              context: context,
              content: 'Account Name is required.'
            );
          } else if (startDate == null) {
            DialogProvider.validationError(
              context: context,
              content: 'Start Date is required.'
            );
          } else {
            if (targetAmountController.text.isEmpty) {
              targetAmountController.text = '0';
            }

            final maturityDate = startDate.addYears(5).addDays(-1);
            final targetAmount = double.parse(targetAmountController.text);

            DialogProvider.confirm(
              context: context,
              subject: 'Account Confirmation',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Are you sure you want to ${isNew ? 'add' : 'update'} this account?'),
                  const Divider(),
                  LabelValue(
                    label: 'Account Name',
                    value: nameController.text,
                    isAmount: false
                  ),
                  LabelValue(
                    label: 'Account Number',
                    value: numberController.text,
                    isAmount: false
                  ),
                  LabelValue(
                    label: 'Payout Type',
                    value: (isYearlyPayout ? 'Yearly Payout' : 'Compounding Interest'),
                    isAmount: false
                  ),
                  LabelValue(
                    label: 'Start Date',
                    value: startDate.toDefaultFormat(),
                    isAmount: false
                  ),
                  LabelValue(
                    label: 'Maturity Date',
                    value: maturityDate.toDefaultFormat(),
                    isAmount: false
                  ),
                  LabelValue(
                    label: 'Target Amount',
                    value: targetAmount.toString()
                  ),
                  LabelValue(
                    label: 'Icon',
                    value: icon.toLabelString(),
                    isAmount: false
                  )
                ]
              ),
              defaultAction: () {
                final service = AccountService();
                final account = Account(
                  id: isNew ? 0 : widget.account!.id,
                  name: nameController.text,
                  number: numberController.text,
                  isYearlyPayout: isYearlyPayout,
                  startDate: startDate,
                  maturityDate: maturityDate,
                  targetAmount: targetAmount,
                  icon: icon
                );

                String task = '';
                if (isNew) {
                  task = 'Created';
                  service.createAccount(account: account);
                } else {
                  task = 'Updated';
                  service.updateAccount(account: account);
                }

                NotificationService().createAndNotify(
                  context: context,
                  notification: NotificationMessage(
                    subject: 'Account $task',
                    content: 'Your account (${account.name}) has been successfully ${task.toLowerCase()}.'
                  )
                );

                Navigate.toAccountList(context);
              }
            );
          }
        },
        tooltip: 'Save',
        child: const Icon(Icons.save)
      )
    );
  }
}
