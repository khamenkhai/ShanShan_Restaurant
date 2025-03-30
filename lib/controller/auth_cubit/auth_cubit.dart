import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shan_shan/core/local_data/shared_prefs.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/model/request_models/shop_login_request_model.dart';
import 'package:shan_shan/model/response_models/shop_model.dart';
import 'package:shan_shan/service/auth_service.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;
  final SharedPref sharedPref;

  AuthCubit({required this.authService, required this.sharedPref})
      : super(AuthInitial());

  /// Check login status
  Future<void> checkLoginStatus() async {
    try {
      String authToken = await sharedPref.getString(
        key: sharedPref.BEARER_TOKEN,
      );

      if (authToken.isEmpty || authToken == "") {
        emit(ShopLogoutState());
      } else {
        final result = await authService.checkLoginStatus(url: "checkLogin");

        result.fold(
          (failure) => emit(ShopLogoutState()), // Handle failure case
          (shop) {
            if (shop.id != null && shop.username != "") {
              emit(ShopLoggedInState(shop: shop));
            } else {
              emit(ShopLogoutState()); // If shop data is incomplete
            }
          },
        );
      }
    } catch (e) {
      emit(ShopLogoutState()); // In case of an unexpected error
    }
  }

  /// Login with shop id
  Future<void> login({required ShopLoginRequest shopLoginRequest}) async {
    emit(ShopLoadingState());
    try {
      final result = await authService.loginWithShop(
        url: "login",
        shopLoginRequest: shopLoginRequest,
      );

      customPrint("=> result : $result");

      result.fold(
        (failure) => emit(ShopFailedState(error: failure)), 
        (shop) {
          sharedPref.setString(
            value: shop.accessToken.toString(),
            key: sharedPref.BEARER_TOKEN,
          );
          emit(ShopLoggedInState(shop: shop));
        },
      );
    } catch (e) {
      emit(ShopFailedState(error: e.toString())); // Emit failure state on error
    }
  }

  /// Logout shop account
  Future<bool> logout() async {
    try {
      final result = await authService.logout(url: "logout");

      result.fold(
        (failure) {
          emit(ShopLogoutState());
          return false;
        },
        (_) {
          sharedPref.setString(key: sharedPref.BEARER_TOKEN, value: "");
          emit(ShopLogoutState());
          return true;
        },
      );
      return false; // Default return if result is not successful
    } catch (e) {
      emit(ShopLogoutState());
      return false; // Return false on any error during logout
    }
  }
}
