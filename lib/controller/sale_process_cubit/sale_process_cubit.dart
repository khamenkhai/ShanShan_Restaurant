import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:shan_shan/model/request_models/sale_request_model.dart';
import 'package:shan_shan/service/sale_service.dart';
import 'package:meta/meta.dart';


part 'sale_process_state.dart';

class SaleProcessCubit extends Cubit<SaleProcessState> {
  final SaleService saleService;

  SaleProcessCubit({required this.saleService}) : super(SaleProcessInitial());

  /// Make Sale
  Future<bool> makeSale({
    required SaleModel saleRequest,
  }) async {
    emit(SaleProcessLoadingState());

    print("sale request : ${jsonEncode(saleRequest.toMap())}");

    try {
      final response = await saleService.makeSale(
        requestBody: saleRequest.toMap(),
      );

      return response.fold(
        (error) {
          emit(SaleProcessFailedState(error: 'Sale failed: $error'));
          return false;
        },
        (success) {
          emit(SaleProcessSuccessState());
          return true;
        },
      );
    } catch (e) {
      emit(SaleProcessFailedState(error: 'make Sale(Cubit) : ${e}'));
      return false;
    }
  }

  /// Update Sale
  Future<bool> updateSale({
    required SaleModel saleRequest,
    required String orderId,
  }) async {
    emit(SaleProcessLoadingState());

    print("sale request : ${jsonEncode(saleRequest.toMap())}");

    try {
      final response = await saleService.makeSale(
        requestBody: saleRequest.toMap(),
      );

      return response.fold(
        (error) {
          emit(SaleProcessFailedState(error: 'Update failed: $error'));
          return false;
        },
        (success) {
          emit(SaleProcessSuccessState());
          return true;
        },
      );
    } catch (e) {
      emit(SaleProcessFailedState(error: 'Update Sale(Cubit) : ${e}'));
      return false;
    }
  }
}
