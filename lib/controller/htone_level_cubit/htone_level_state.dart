
import 'package:shan_shan/models/data_models/ahtone_level_model.dart';

sealed class HtoneLevelState {}

final class AhtoneLevelCrudInitial extends HtoneLevelState {}

final class AhtoneLevelLoading extends HtoneLevelState {}

final class HtoneLevelLoaded extends HtoneLevelState {
  final List<AhtoneLevelModel> htoneLevels;
  HtoneLevelLoaded({required this.htoneLevels});
}

final class AhtoneLevelCreated extends HtoneLevelState {}

final class AhtoneLevelDeleted extends HtoneLevelState {}

final class AhtoneLevelError extends HtoneLevelState {
  final String message;
  AhtoneLevelError({required this.message});
}

final class AhtoneLevelUpdated extends HtoneLevelState {}
