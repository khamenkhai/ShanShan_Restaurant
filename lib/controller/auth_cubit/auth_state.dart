part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class ShopLoadingState extends AuthState {}

final class ShopLoggedInState extends AuthState {
  final ShopModel shop;
  ShopLoggedInState({required this.shop});
}

final class ShopLogoutState extends AuthState {}


final class ShopFailedState extends AuthState {
  final String error;
  ShopFailedState({required this.error});
}
