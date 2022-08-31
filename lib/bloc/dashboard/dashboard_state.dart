part of 'dashboard_cubit.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSuccess extends DashboardState {}

class DashboardError extends DashboardState {
  final String errorMessage;
  DashboardError(this.errorMessage);
}

class LogoutSuccess extends DashboardState {}

class MemberJoined extends DashboardState {}

class SplitChanged extends DashboardState {}

class GroupNotFound extends DashboardState {}
