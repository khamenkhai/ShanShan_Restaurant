import 'package:bloc/bloc.dart';
import 'package:shan_shan/model/response_models/category_model.dart';
import 'package:shan_shan/service/category_service.dart';
part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryService categoryService;

  CategoryCubit({required this.categoryService}) : super(CategoryInitial());

  /// Get All Categories
  Future<void> getAllCategories() async {
    emit(CategoryLoadingState());
    final result = await categoryService.getAllCategories();
    result.fold(
      (failure) => emit(CategoryErrorState(error: failure)),
      (categories) => emit(CategoryLoadedState(categoryList: categories)),
    );
  }

  /// Create Category
  Future<void> createCategory({
    required String name,
    required String description,
  }) async {
    emit(CategoryLoadingState());
    final result = await categoryService.createCategory(
      requestBody: {"name": name, "description": description},
    );
    result.fold(
      (failure) => emit(CategoryErrorState(error: failure)),
      (_) async {
        emit(CategoryCreatedState());
        await getAllCategories();
      },
    );
  }

  /// Delete Category
  Future<void> deleteCategory({required String id}) async {
    emit(CategoryLoadingState());
    final result = await categoryService.deleteCategory(id: id);
    result.fold(
      (failure) => emit(CategoryErrorState(error: failure)),
      (_) async {
        emit(CategoryDeletedState());
        await getAllCategories();
      },
    );
  }

  /// Update Category
  Future<void> updateCategory({
    required String id,
    required String name,
    required String description,
  }) async {
    emit(CategoryLoadingState());
    final result = await categoryService.updateCategory(
      id: id,
      requestBody: {"name": name, "description": description},
    );
    result.fold(
      (failure) => emit(CategoryErrorState(error: failure)),
      (_) async {
        emit(CategoryUpdatedState());
        await getAllCategories();
      },
    );
  }
}
