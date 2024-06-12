class Contribution {
  int id;
  final int accountId;
  final double amount;
  DateTime date;

  Contribution({
    this.id = 0,
    required this.accountId,
    required this.amount,
    required this.date
  });

  factory Contribution.fromSqflite(Map<String, dynamic> map) => Contribution(
    id: map['id'],
    accountId: map['accountId'],
    amount: map['amount'].toDouble(),
    date: DateTime.fromMillisecondsSinceEpoch(map['date'])
  );

  Map<String, dynamic> toSqflite() {
    return {
      'accountId': accountId,
      'amount': amount,
      'date': date.millisecondsSinceEpoch
    };
  }
}
