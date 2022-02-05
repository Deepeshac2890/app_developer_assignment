import 'package:app_developer_assignment/model/HeaderData.dart';

import '../model/customRecommendationModel.dart';

class DashboardState {
  DashboardState init() {
    return DashboardState();
  }

  DashboardState clone() {
    return DashboardState();
  }
}

class PageLoadedState extends DashboardState {
  final List<Tournaments> listOfTournaments;
  final bool dataNotFound;
  final HeaderData hd;

  PageLoadedState({
    required this.hd,
    required this.dataNotFound,
    required this.listOfTournaments,
  });
}

class InitialPageLoadedState extends DashboardState {
  final List<Tournaments> listOfTournaments;
  final bool dataNotFound;
  final HeaderData hd;

  InitialPageLoadedState({
    required this.hd,
    required this.dataNotFound,
    required this.listOfTournaments,
  });
}

class HeaderLoadFailed extends DashboardState {}
