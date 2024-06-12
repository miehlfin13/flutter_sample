class CustomDividend {
  final int id;
  final int accountId;
  final int year;
  final double rate;
  
  CustomDividend({
    this.id = 0,
    required this.accountId,
    required this.year,
    required this.rate
  });

  factory CustomDividend.fromSqflite(Map<String, dynamic> map) => CustomDividend(
    id: map['id'],
    accountId: map['accountId'],
    year: map['year'],
    rate: map['rate']
  );

  Map<String, dynamic> toSqflite() {
    return {
      'accountId': accountId,
      'year': year,
      'rate': rate,
    };
  }
}
