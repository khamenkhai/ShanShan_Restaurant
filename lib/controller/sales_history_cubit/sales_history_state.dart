import 'package:flutter/material.dart';
import 'package:shan_shan/model/response_models/sale_history_model.dart';

@immutable
sealed class SalesHistoryState {}

final class SalesHistoryInitial extends SalesHistoryState {}

final class SalesHistoryLoadingState extends SalesHistoryState {}

final class SalesHistoryLoadedState extends SalesHistoryState {
  final List<SaleHistoryModel> history;
  SalesHistoryLoadedState({required this.history});
}

final class SalesHistoryErrorState extends SalesHistoryState {
  final String error;
  SalesHistoryErrorState({required this.error});
}
