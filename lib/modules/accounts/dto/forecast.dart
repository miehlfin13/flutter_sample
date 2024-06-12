import 'package:mp2_tracker/modules/forecast/enums/forecast_type.dart';

class Forecast {
  double amount;
  final DateTime startDate;
  final DateTime endDate;
  final ForecastType type;

  Forecast({
    this.amount = 0,
    required this.startDate,
    required this.endDate,
    required this.type,
  });
}

