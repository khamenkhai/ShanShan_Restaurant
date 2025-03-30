import 'package:bloc/bloc.dart';
import 'package:shan_shan/controller/spicy_level_crud_cubit/spicy_level_state.dart';
import 'package:shan_shan/service/spicy_level_service.dart';

class SpicyLevelCubit extends Cubit<SpicyLevelCrudState> {
  final SpicyLevelService spicyLevelService;

  SpicyLevelCubit({required this.spicyLevelService})
      : super(SpicyLevelCrudInitial());

  /// Create Spicy Level
  Future<void> addNewSpicy({
    required String levelName,
    required String description,
    required int position,
  }) async {
    emit(SpicyLevelLoading());
    final result = await spicyLevelService.addSpicyLevel(
      requestBody: {
        "name": levelName,
        "description": description,
        "position": position,
      },
    );

    result.fold(
      (failure) => emit(SpicyLevelError(message: failure)),
      (_) async {
        emit(SpicyLevelCreated());
        await getAllLevels();
      },
    );
  }

  /// Delete Spicy Level
  Future<void> deleteSpicyLevel({required String id}) async {
    emit(SpicyLevelLoading());
    final result = await spicyLevelService.deleteSpicyLevel(id: id);

    result.fold(
      (failure) => emit(SpicyLevelError(message: failure)),
      (_) async {
        emit(SpicyLevelDeleted());
        await getAllLevels();
      },
    );
  }

  /// Update Spicy Level
  Future<void> editSpicyLevel({
    required String id,
    required String name,
    required String description,
    required int position,
  }) async {
    emit(SpicyLevelLoading());
    final result = await spicyLevelService.editSpicyLevel(
      id: id,
      requestBody: {
        "name": name,
        "description": description,
        "position": position,
      },
    );

    result.fold(
      (failure) => emit(SpicyLevelError(message: failure)),
      (_) async {
        emit(SpicyLevelUpdated());
        await getAllLevels();
      },
    );
  }

  /// Get all Spicy Levels
  Future<void> getAllLevels() async {
    emit(SpicyLevelLoading());
    final result = await spicyLevelService.getSpicyLevels();

    result.fold(
      (failure) => emit(SpicyLevelError(message: failure)),
      (levels) => emit(SpicyLevelLoaded(spicy_level: levels)),
    );
  }
}
