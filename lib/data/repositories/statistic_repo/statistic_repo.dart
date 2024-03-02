import 'package:three_tapp_app/model/statistic.dart';

abstract class StatisticRepo {
  Future<Statistic> getStatistic(String? email);
}
