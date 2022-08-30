part of 'split_cubit.dart';

abstract class SplitState {}

class SplitInitial extends SplitState {}

class SplitLoading extends SplitState {}

class SplitSuccess extends SplitState {}

class SplitChanged extends SplitState {}

class SplitError extends SplitState {
  final String errorMessage;
  SplitError(this.errorMessage);
}
