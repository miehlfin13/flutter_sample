import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/accounts/dto/forecast.dart';
import 'package:mp2_tracker/modules/accounts/dto/periodic_contribution.dart';
import 'package:mp2_tracker/modules/accounts/enums/contribution_type.dart';
import 'package:mp2_tracker/modules/forecast/enums/forecast_type.dart';
import 'package:mp2_tracker/shared/extensions/date_extension.dart';
import 'package:mp2_tracker/shared/extensions/forecast_type_extension.dart';
import 'package:mp2_tracker/shared/extensions/int_extension.dart';
import 'package:mp2_tracker/shared/widgets/label_value.dart';
import 'package:flutter/cupertino.dart';

class DialogProvider {
  static _create({
    required BuildContext context,
    required String subject,
    required Widget content,
    required List<CupertinoDialogAction> actions
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
        CupertinoAlertDialog(
          title: Text(subject),
          content: content,
          actions: actions
        )
    );
  }

  static info({required BuildContext context, required String subject, required Widget content}) {
    _create(
      context: context,
      subject: subject,
      content: content,
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK')
        )
      ]
    );
  }

  static validationError({required BuildContext context, required String content}) {
    info(context: context, subject: 'Validation Error', content: Text(content));
  }
  
  static noInternetConection({required BuildContext context, required void Function() action}) {
    _create(
      context: context,
      subject: 'No Connection',
      content: const Text('Please check your internet connectivity'),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop();
            action();
          },
          child: const Text('OK')
        )
      ]
    );
  }

  static confirm({required BuildContext context, required String subject, required Widget content,
                  void Function()? defaultAction, List<CupertinoDialogAction>? actions}) {
    _create(
      context: context,
      subject: subject,
      content: content,
      actions: [
        ...(actions ?? []),
        ...(defaultAction == null
          ? []
          : [CupertinoDialogAction(onPressed: defaultAction, child: const Text('OK'))]
        ),
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel')
        )
      ]
    );
  }

  static confirmPeriodicContribution({
    required BuildContext context,
    required String subject,
    required String content,
    required PeriodicContribution periodicContribution,
    required void Function() action,
    bool isForecast = true
  }) {
    List<Widget> widgets = [
      LabelValue(
        label: 'Contribution Type',
        value: periodicContribution.type.toLabel(),
        isAmount: false
      )
    ];

    if(periodicContribution.type == ContributionType.day) {
      widgets.add(LabelValue(
        label: 'Date',
        value: periodicContribution.startDate.toDefaultFormat(),
        isAmount: false
      ));
    } else {
      widgets.add(LabelValue(
        label: isForecast ? 'Start Date' : 'Date From',
        value: periodicContribution.startDate.toDefaultFormat(),
        isAmount: false
      ));

      widgets.add(LabelValue(
        label: isForecast ? 'Maturity Date' : 'Date To',
        value: periodicContribution.endDate.toDefaultFormat(),
        isAmount: false
      ));

      if (periodicContribution.type == ContributionType.weekly) {
        widgets.add(LabelValue(
          label: 'Day of Week',
          value: periodicContribution.dayOfWeek.toFullWeekString(),
          isAmount: false
        ));
      } else {
        if (periodicContribution.type == ContributionType.yearly) {
          widgets.add(LabelValue(
            label: 'Month',
            value: periodicContribution.monthOfYear.toFullMonthString(),
            isAmount: false
          ));
        }
        widgets.add(LabelValue(
          label: 'Day of Month',
          value: periodicContribution.dayOfMonth.toString(),
          isAmount: false
        ));
      }
      widgets.add(LabelValue(
        label: 'Amount',
        value: periodicContribution.amount.toString()
      ));

      if (periodicContribution.type == ContributionType.monthly || periodicContribution.type == ContributionType.yearly) {
        if (periodicContribution.dayOfMonth > 28) {
          widgets.add(const Text(''));
          widgets.add(const Text('Note: if the selected day of month is not existing, the last day of month will be used instead'));
        }
      }
    }

    confirm(
      context: context,
      subject: subject,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(content),
          const Divider(),
          ...widgets
        ]
      ),
      defaultAction: action
    );
  }

  static confirmForecast({
    required BuildContext context,
    required Forecast forecast,
    required void Function() action,
  }) {
    List<Widget> widgets = [
      LabelValue(
        label: 'Start Date',
        value: forecast.startDate.toDefaultFormat(),
        isAmount: false
      ),
      LabelValue(
        label: 'Maturity Date',
        value: forecast.endDate.toDefaultFormat(),
        isAmount: false
      ),
      LabelValue(
        label: forecast.type == ForecastType.targetAmount ? 'Approximate Target Amount' : 'Amount',
        value: forecast.amount.toString()
      )
    ];
    
    confirm(
      context: context,
      subject: '${forecast.type.toLabelString()} Forecast Confirmation',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Are you sure you want to add this forecast?'),
          const Divider(),
          ...widgets
        ]
      ),
      defaultAction: action
    );
  }
}