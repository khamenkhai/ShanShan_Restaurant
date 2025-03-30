
import 'package:shan_shan/model/data_models/ahtone_level_model.dart';

sealed class AhtoneLevelCrudState {}

final class AhtoneLevelCrudInitial extends AhtoneLevelCrudState {}

final class AhtoneLevelLoading extends AhtoneLevelCrudState {}

final class AhtoneLevelLoaded extends AhtoneLevelCrudState {
  final List<AhtoneLevelModel> ahtone_level;
  AhtoneLevelLoaded({required this.ahtone_level});
}

final class AhtoneLevelCreated extends AhtoneLevelCrudState {}

final class AhtoneLevelDeleted extends AhtoneLevelCrudState {}

final class AhtoneLevelError extends AhtoneLevelCrudState {
  final String message;
  AhtoneLevelError({required this.message});
}

final class AhtoneLevelUpdated extends AhtoneLevelCrudState {}
