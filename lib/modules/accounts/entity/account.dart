import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/accounts/entity/contribution.dart';
import 'package:mp2_tracker/modules/accounts/enums/account_status.dart';

class Account {
    int id;
    final String name;
    final String number;
    final bool isYearlyPayout;
    final DateTime startDate;
    final DateTime maturityDate;
    final DateTime? claimDate;
    final DateTime? deletedDate;
    final double targetAmount;
    final IconData icon;
    final AccountStatus status;

    List<Contribution> contributions = [];
    
    Account({
      this.id = 0,
      required this.name,
      this.number = '',
      required this.isYearlyPayout,
      required this.startDate,
      required this.maturityDate,
      this.claimDate,
      this.deletedDate,
      this.targetAmount = 0,
      this.icon = Icons.attach_money,
      this.status = AccountStatus.active,
    });

    factory Account.fromSqflite(Map<String, dynamic> map) => Account(
      id: map['id'],
      name: map['name'],
      number: map['number'] ?? '',
      isYearlyPayout: map['isYearlyPayout'] == 0 ? false : true, 
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      maturityDate: DateTime.fromMillisecondsSinceEpoch(map['maturityDate']),
      claimDate: map['claimDate'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['claimDate']),
      deletedDate: map['deletedDate'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['deletedDate']),
      targetAmount: map['targetAmount'] ?? 0,
      icon: IconData(map['icon'] ?? Icons.attach_money.codePoint, fontFamily: 'MaterialIcons'),
      status: AccountStatus.values[map['status']]
    );

    Map<String, dynamic> toSqflite() {
      return {
        'name': name,
        'number': number,
        'isYearlyPayout': isYearlyPayout ? 1 : 0,
        'startDate': startDate.millisecondsSinceEpoch,
        'maturityDate': maturityDate.millisecondsSinceEpoch,
        'claimDate': claimDate?.millisecondsSinceEpoch,
        'deletedDate': deletedDate?.millisecondsSinceEpoch,
        'targetAmount': targetAmount,
        'icon': icon.codePoint,
        'status': status.index
      };
    }

    bool isMatured() {
      return maturityDate.isBefore(DateTime.now());
    }
}
