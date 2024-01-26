import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:three_tapp_app/base/baseviewmodel/base_viewmodel.dart';
import 'package:three_tapp_app/data/repositories/statistic_repo/statistic_repo_impl.dart';
import 'package:three_tapp_app/model/statistic.dart';

class StatisticViewModel extends BaseViewModel {
  static final StatisticRepoImpl statisticRepo = StatisticRepoImpl();
  static final StatisticViewModel _instance = StatisticViewModel._internal();

  factory StatisticViewModel() {
    return _instance;
  }

  User? currentUser;

  StatisticViewModel._internal();
  @override
  FutureOr<void> init() {
    //Khoi tao nguoi dung hien tai
    currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<Statistic> getStatisticOfCurrentUser() {
    return statisticRepo.getStatistic(currentUser!.email);
  }
}
