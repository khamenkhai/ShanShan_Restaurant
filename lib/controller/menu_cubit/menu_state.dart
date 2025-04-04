import 'package:shan_shan/models/response_models/menu_model.dart';

sealed class MenuState {}

final class MenuInitial extends MenuState {}

final class MenuLoadingState extends MenuState {}

final class MenuCreated extends MenuState {}

final class MenuUpdated extends MenuState {}

final class MenuDeleted extends MenuState {}

final class MenuLoadedState extends MenuState {
  final List<MenuModel> menuList;
  MenuLoadedState({required this.menuList});
}

final class MenuErrorState extends MenuState {
  final String error;
  MenuErrorState({required this.error});
}
