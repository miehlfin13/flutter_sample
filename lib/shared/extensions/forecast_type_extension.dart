import 'package:mp2_tracker/modules/forecast/enums/forecast_type.dart';

extension ForecastTypeExtension on ForecastType {
  String toAcronym() {
    return switch(this) {
      ForecastType.periodicContribution => 'PC',
      ForecastType.oneTimePayment => 'OTP',
      ForecastType.targetAmount => 'TA',
    };
  }

  String toLabelString() {
    return switch(this) {
      ForecastType.periodicContribution => 'Periodic Contribution',
      ForecastType.oneTimePayment => 'One-Time Payment',
      ForecastType.targetAmount => 'Target Amount',
    };
  }
}
