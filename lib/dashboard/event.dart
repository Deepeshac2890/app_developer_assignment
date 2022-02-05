import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class DashboardEvent {}

class InitEvent extends DashboardEvent {}

class GetNextPageEvent extends DashboardEvent {
  final RefreshController controller;

  GetNextPageEvent(this.controller);
}

class LoadData extends DashboardEvent {
  LoadData();
}