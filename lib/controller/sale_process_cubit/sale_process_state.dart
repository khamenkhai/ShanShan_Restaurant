part of 'sale_process_cubit.dart';

@immutable
sealed class SaleProcessState {}

final class SaleProcessInitial extends SaleProcessState {}

final class SaleProcessLoadingState extends SaleProcessState {}

final class SaleProcessSuccessState extends SaleProcessState {
  // final SaleResponseModel saleResponse;
  // SaleProcessSuccessState({required this.saleResponse});
}

final class SaleProcessFailedState extends SaleProcessState {
  final String error;
  SaleProcessFailedState({required this.error});
}
