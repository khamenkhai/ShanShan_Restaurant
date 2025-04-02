import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/sales_history_cubit/sales_history_state.dart';
import 'package:shan_shan/model/response_models/sale_history_model.dart';
import 'package:shan_shan/service/history_service.dart';

class SalesHistoryCubit extends Cubit<SalesHistoryState> {
  final HistoryService historyService;

  SalesHistoryCubit({required this.historyService})
      : super(SalesHistoryInitial());

  /// Get history list by pagination
  Future<void> getHistoryByPagination({required int page}) async {
    emit(SalesHistoryLoadingState());
    final result = await historyService.getHistoriesByPagination(
      requestBody: {},
    );

    result.fold(
      (failure) => emit(SalesHistoryErrorState(error: failure)),
      (historyList) => emit(SalesHistoryLoadedState(history: historyList)),
    );
  }

  /// Search sale history by query
  Future<void> searchHistory({required String query}) async {
    emit(SalesHistoryLoadingState());
    final result = await historyService.searchSaleHistory(
      requestBody: {"slip_number": query},
    );

    result.fold(
      (failure) => emit(SalesHistoryErrorState(error: failure)),
      (historyList) => emit(SalesHistoryLoadedState(history: historyList)),
    );
  }

  /// Load more sale history by pagination
  Future<void> loadMoreHistory({
    required Map<String, dynamic> requestBody,
    required int page,
  }) async {
    final result = await historyService.getHistoriesByPagination(
      requestBody: requestBody,
    );

    result.fold(
      (failure) => emit(SalesHistoryErrorState(error: failure)),
      (moreHistories) {
        SalesHistoryState currentState = state;

        if (currentState is SalesHistoryLoadedState) {
          List<SaleHistoryModel> histories = currentState.history + moreHistories;
          emit(SalesHistoryLoadedState(
            history: histories,
          ));
        } else {
          emit(SalesHistoryErrorState(error: 'Invalid state'));
        }
      },
    );
  }
}
