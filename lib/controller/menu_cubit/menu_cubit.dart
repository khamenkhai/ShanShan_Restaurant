import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/menu_cubit/menu_state.dart';
import 'package:shan_shan/core/const/api_const.dart';
import 'package:shan_shan/service/menu_service.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuService menuService;

  MenuCubit({required this.menuService}) : super(MenuInitial());

  /// Get all menu list
  Future<void> getMenu() async {
    emit(MenuLoadingState());
    final result = await menuService.getMenuList(
      url: ApiConstants.GET_MENU_LIST,
    );

    result.fold(
      (failure) => emit(MenuErrorState(error: failure)),
      (menuList) => emit(MenuLoadedState(menuList: menuList)),
    );
  }

  /// Create menu
  Future<bool> addMenu({required String menuName, required bool isTaseRequired}) async {
    emit(MenuLoadingState());
    final result = await menuService.createMenu(
      requestBody: {"name": menuName, "isFish": isTaseRequired},
    );

    result.fold(
      (failure) => emit(MenuErrorState(error: failure)),
      (_) {
        emit(MenuCreated());
        getMenu();
      },
    );
    return result.isRight();
  }

  /// Delete menu
  Future<bool> deleteMenu({required String id}) async {
    emit(MenuLoadingState());
    final result = await menuService.deleteMenu(
      id: id,
      requestBody: {},
    );

    result.fold(
      (failure) => emit(MenuErrorState(error: failure)),
      (_) {
        emit(MenuDeleted());
        getMenu();
      },
    );
    return result.isRight();
  }

  /// Update menu
  Future<bool> editMenu({
    required String id,
    required String name,
    required bool isTaseRequired,
  }) async {
    emit(MenuLoadingState());
    final result = await menuService.editMenu(
      id: id,
      requestBody: {
        "name": name,
        "isFish": isTaseRequired,
      },
    );

    result.fold(
      (failure) => emit(MenuErrorState(error: failure)),
      (_) {
        emit(MenuUpdated());
        getMenu();
      },
    );
    return result.isRight();
  }
}
