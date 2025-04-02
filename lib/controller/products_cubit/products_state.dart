part of 'products_cubit.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}

final class ProductsLoadingState extends ProductsState {}

final class ProductsAddingState extends ProductsState {}

final class ProductsUpdatingState extends ProductsState {}

final class ProductsDeletingState extends ProductsState {}

final class ProductAddedState extends ProductsState {}

final class ProductUpdatedState extends ProductsState {}

final class ProductDeletedState extends ProductsState {}

final class ProductsLoadedState extends ProductsState {
  final List<ProductModel> products;
  ProductsLoadedState({required this.products});
}

final class ProductsErrorState extends ProductsState {
  final String error;
  ProductsErrorState({required this.error});
}
