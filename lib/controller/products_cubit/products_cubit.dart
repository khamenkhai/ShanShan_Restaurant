import 'package:bloc/bloc.dart';
import 'package:shan_shan/model/response_models/product_model.dart';
import 'package:shan_shan/service/products_service.dart';
import 'package:meta/meta.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductService productService;

  ProductsCubit({required this.productService}) : super(ProductsInitial());

  /// Get all products by pagination
  Future<void> getAllProducts() async {
    emit(ProductsLoadingState());
    final result = await productService.getAllProducts();
    result.fold(
      (failure) => emit(ProductsErrorState(error: 'Failed to fetch all products : $failure')),
      (products) => emit(ProductsLoadedState(products: products)),
    );
  }

  /// Get products by category
  Future<void> getProductsByCategory({
    required Map<String, dynamic> requestBody,
  }) async {
    emit(ProductsLoadingState());
    final result = await productService.getProductsByCategory(requestBody: requestBody);
    result.fold(
      (failure) => emit(ProductsErrorState(error: 'Failed to fetch products by category: $failure')),
      (products) => emit(ProductsLoadedState(products: products)),
    );
  }

  /// Load more products by pagination
  Future<void> loadMoreProducts({
    required Map<String, dynamic> requestBody,
  }) async {
    final result = await productService.getProductsByPagination(requestBody: requestBody);
    result.fold(
      (failure) => emit(ProductsErrorState(error: 'Failed to load more products: $failure')),
      (products) {
        if (state is ProductsLoadedState) {
          final currentState = state as ProductsLoadedState;
          final allProducts = currentState.products + products;
          emit(ProductsLoadedState(products: allProducts));
        }
      },
    );
  }

  /// Add new product
  Future<void> addNewProduct({
    required Map<String, dynamic> requestBody,
  }) async {
    emit(ProductsLoadingState());
    final result = await productService.addNewProduct(requestBody: requestBody);
    result.fold(
      (failure) => emit(ProductsErrorState(error: 'Failed to add product: $failure')),
      (_) async {
        emit(ProductAddedState());
        await getAllProducts();
      },
    );
  }

  /// Update product
  Future<void> updateProduct({
    required String id,
    required Map<String, dynamic> requestBody,
  }) async {
    emit(ProductsLoadingState());
    final result = await productService.updateProduct(id: id, requestBody: requestBody);
    result.fold(
      (failure) => emit(ProductsErrorState(error: 'Failed to update product: $failure')),
      (_) async {
        emit(ProductUpdatedState());
        await getAllProducts();
      },
    );
  }

  /// Delete product
  Future<void> deleteProduct({
    required String id,
  }) async {
    emit(ProductsLoadingState());
    final result = await productService.deleteProduct(id: id, requestBody: {});
    result.fold(
      (failure) => emit(ProductsErrorState(error: 'Failed to delete product: $failure')),
      (_) async {
        emit(ProductDeletedState());
        await getAllProducts();
      },
    );
  }

}
