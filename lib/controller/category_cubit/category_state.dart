part of 'category_cubit.dart';

sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}

final class CategoryLoadingState extends CategoryState {}

final class CategoryCreatedState extends CategoryState {}

final class CategoryDeletedState extends CategoryState {}

final class CategoryUpdatedState extends CategoryState {}

final class CategoryLoadedState extends CategoryState {
  final List<CategoryModel> categoryList;
  CategoryLoadedState({required this.categoryList});
}

final class CategoryErrorState extends CategoryState {
  final String error;
  CategoryErrorState({required this.error});
}
