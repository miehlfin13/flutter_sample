import 'package:mp2_tracker/modules/dividends/entity/dividend.dart';
import 'package:mp2_tracker/modules/dividends/services/dividend_service.dart';

class DividendDataProvider {
  static Future<void> initializeDefaultData() async {
    final service = DividendService();
    await service.create(dividend: Dividend(id: 1, year: 2011, rate: 4.63));
    await service.create(dividend: Dividend(id: 2, year: 2012, rate: 4.67));
    await service.create(dividend: Dividend(id: 3, year: 2013, rate: 4.58));
    await service.create(dividend: Dividend(id: 4, year: 2014, rate: 4.69));
    await service.create(dividend: Dividend(id: 5, year: 2015, rate: 5.34));
    await service.create(dividend: Dividend(id: 6, year: 2016, rate: 7.43));
    await service.create(dividend: Dividend(id: 7, year: 2017, rate: 8.11));
    await service.create(dividend: Dividend(id: 8, year: 2018, rate: 7.41));
    await service.create(dividend: Dividend(id: 9, year: 2019, rate: 7.23));
    await service.create(dividend: Dividend(id: 10, year: 2020, rate: 6.12));
    await service.create(dividend: Dividend(id: 11, year: 2021, rate: 6.00));
    await service.create(dividend: Dividend(id: 12, year: 2022, rate: 7.03));
    await service.create(dividend: Dividend(id: 13, year: 2023, rate: 7.05));
  }
}
