import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/htone_level_cubit/htone_level_state.dart';
import 'package:shan_shan/service/ahtone_level_service.dart';

class HtoneLevelCubit extends Cubit<AhtoneLevelCrudState> {
  final AhtoneLevelService ahtoneLevelService;

  HtoneLevelCubit({required this.ahtoneLevelService})
      : super(AhtoneLevelCrudInitial());

  /// Create Ahtone Level
  Future<void> addNewAhtone({
    required String levelName,
    required String description,
    required int position,
  }) async {
    emit(AhtoneLevelLoading());
    final result = await ahtoneLevelService.addAhtoneLevel(
      requestBody: {
        "name": levelName,
        "description": description,
        "position": position,
      },
    );

    result.fold(
      (failure) => emit(AhtoneLevelError(message: failure)),
      (_) async {
        emit(AhtoneLevelCreated());
        await getAllLevels();
      },
    );
  }

  /// Delete Ahtone Level
  Future<void> deleteAhtoneLevel({required String id}) async {
    emit(AhtoneLevelLoading());
    final result = await ahtoneLevelService.deleteAhtoneLevel(
      id: id,
      requestBody: {},
    );

    result.fold(
      (failure) => emit(AhtoneLevelError(message: failure)),
      (_) async {
        emit(AhtoneLevelDeleted());
        await getAllLevels();
      },
    );
  }

  /// Update Ahtone Level
  Future<void> editAhtoneLevel({
    required String id,
    required String name,
    required String description,
    required int position,
  }) async {
    emit(AhtoneLevelLoading());
    final result = await ahtoneLevelService.editAhtoneLevel(
      id: id,
      requestBody: {
        "name": name,
        "description": description,
        "position": position,
      },
    );

    result.fold(
      (failure) => emit(AhtoneLevelError(message: failure)),
      (_) async {
        emit(AhtoneLevelUpdated());
        await getAllLevels();
      },
    );
  }

  /// Get all Ahtone Levels
  Future<void> getAllLevels() async {
    emit(AhtoneLevelLoading());
    final result = await ahtoneLevelService.getAllAthoneLevels();

    result.fold(
      (failure) => emit(AhtoneLevelError(message: failure)),
      (levels) => emit(AhtoneLevelLoaded(ahtone_level: levels)),
    );
  }
}
