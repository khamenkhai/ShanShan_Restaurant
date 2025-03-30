import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'internet_connection_state.dart';

class InternetConnectionCubit extends Cubit<InternetConnectionState> {
  
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;

  InternetConnectionCubit() : super(InternetConnectionInitial()) {
    // Subscribe to connectivity changes
    connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (result) {
        emit(InternetLoadingState());
        if (result.contains(ConnectivityResult.mobile) ||
            result.contains(ConnectivityResult.wifi)) {
          emit(InternetConnectedState());
        } else {
          emit(InternetDisconnectedState());
        }
      },
      onError: (error) {
        emit(InternetDisconnectedState());
      },
    );
  }

  //Method to trigger a manual internet connectivity check
  void tryAgainInternet() {
    emit(InternetLoadingState());
    Connectivity().checkConnectivity().then((result) {
      if (result.contains(ConnectivityResult.mobile)) {
        emit(InternetConnectedState());
      } else if (result.contains(ConnectivityResult.wifi)) {
        emit(InternetConnectedState());
      } else {
        emit(InternetDisconnectedState());
      }
    }).catchError((error) {
      emit(InternetDisconnectedState());
    });
  }

  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    return super.close();
  }
}
