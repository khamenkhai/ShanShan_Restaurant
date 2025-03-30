import 'package:shan_shan/model/data_models/spicy_level.dart';

sealed class SpicyLevelCrudState {}

final class SpicyLevelCrudInitial extends SpicyLevelCrudState {}

final class SpicyLevelLoading extends SpicyLevelCrudState {}

final class SpicyLevelLoaded extends SpicyLevelCrudState {
  final List<SpicyLevelModel> spicy_level;
  SpicyLevelLoaded({required this.spicy_level});
}

final class SpicyLevelCreated extends SpicyLevelCrudState {}

final class SpicyLevelDeleted extends SpicyLevelCrudState {}

final class SpicyLevelError extends SpicyLevelCrudState {
  final String message;
  SpicyLevelError({required this.message});
}

final class SpicyLevelUpdated extends SpicyLevelCrudState {}
