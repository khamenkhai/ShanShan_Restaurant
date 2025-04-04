
import 'package:shan_shan/models/data_models/ahtone_level_model.dart';

sealed class AhtoneLevelCrudState {}

final class AhtoneLevelCrudInitial extends AhtoneLevelCrudState {}

final class AhtoneLevelLoading extends AhtoneLevelCrudState {}

final class AhtoneLevelLoaded extends AhtoneLevelCrudState {
  final List<AhtoneLevelModel> htoneLevels;
  AhtoneLevelLoaded({required this.htoneLevels});
}

final class AhtoneLevelCreated extends AhtoneLevelCrudState {}

final class AhtoneLevelDeleted extends AhtoneLevelCrudState {}

final class AhtoneLevelError extends AhtoneLevelCrudState {
  final String message;
  AhtoneLevelError({required this.message});
}

final class AhtoneLevelUpdated extends AhtoneLevelCrudState {}
