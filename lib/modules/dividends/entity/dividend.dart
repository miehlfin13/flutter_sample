class Dividend {
  final int id;
  final int year;
  final double rate;

  Dividend({
    required this.id,
    required this.year,
    required this.rate
  });

  factory Dividend.fromSqflite(Map<String, dynamic> map) => Dividend(
    id: map['id'],
    year: map['year'],
    rate: map['rate']
  );

  Map<String, dynamic> toSqflite() {
    return {
      'id': id,
      'year': year,
      'rate': rate,
    };
  }
}
