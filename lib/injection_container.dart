import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shan_shan/controller/htone_level_cubit/htone_level_cubit.dart';
import 'package:shan_shan/controller/auth_cubit/auth_cubit.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:shan_shan/controller/internet_cubit/internet_connection_cubit.dart';
import 'package:shan_shan/controller/menu_cubit/menu_cubit.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/controller/category_cubit/category_cubit.dart';
import 'package:shan_shan/controller/products_cubit/products_cubit.dart';
import 'package:shan_shan/controller/sale_process_cubit/sale_process_cubit.dart';
import 'package:shan_shan/controller/sale_report_cubit/sale_report_cubit.dart';
import 'package:shan_shan/controller/sales_history_cubit/sales_history_cubit.dart';
import 'package:shan_shan/controller/spicy_level_crud_cubit/spicy_level_cubit.dart';
import 'package:shan_shan/controller/theme_cubit/theme_cubit.dart';
import 'package:shan_shan/core/const/api_const.dart';
import 'package:shan_shan/core/local_data/shared_prefs.dart';
import 'package:shan_shan/core/network/dio_client.dart';
import 'package:shan_shan/core/service/local_noti_service.dart';
import 'package:shan_shan/core/utils/custom_logger.dart';
import 'package:shan_shan/service/ahtone_level_service.dart';
import 'package:shan_shan/service/auth_service.dart';
import 'package:shan_shan/service/category_service.dart';
import 'package:shan_shan/service/history_service.dart';
import 'package:shan_shan/service/menu_service.dart';
import 'package:shan_shan/service/products_service.dart';
import 'package:shan_shan/service/report_service.dart';
import 'package:shan_shan/service/sale_service.dart';
import 'package:shan_shan/service/spicy_level_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

///primary initializiation for primary app∏
void primaryInit() {
  //blocs / cubits
  getIt.registerFactory(() => InternetConnectionCubit());
  getIt.registerFactory(() => AuthCubit(authService: getIt.call(), sharedPref: getIt.call()));
  getIt.registerFactory(() => ProductsCubit(productService: getIt.call()));
  getIt.registerFactory(() => CartCubit());
  getIt.registerFactory(() => CategoryCubit(categoryService: getIt.call()));
  getIt.registerFactory(() => MenuCubit(menuService: getIt.call()));
  getIt.registerFactory(() => SaleProcessCubit(saleService: getIt.call()));
  getIt.registerFactory(() => SalesHistoryCubit(historyService: getIt.call()));
  getIt.registerFactory(() => HtoneLevelCubit(ahtoneLevelService: getIt.call()));
  getIt.registerFactory(() => SpicyLevelCubit(spicyLevelService: getIt.call()));
  getIt.registerFactory(() => SaleReportCubit(reportService: getIt.call()));
  getIt.registerFactory(() => OrderEditCubit());
  getIt.registerFactory(() => ThemeCubit(sharedPref: getIt.call()));

  //services
  getIt.registerLazySingleton(() => AuthService(dioClient: getIt.call(), logger: getIt.call()));
  getIt.registerLazySingleton(() => ProductService(dioClient: getIt.call(), logger: getIt.call()));
  getIt.registerLazySingleton(() => CategoryService(dioClient: getIt.call(), logger: getIt.call()));
  getIt.registerLazySingleton(() => SaleService(dioClient: getIt.call(), logger: getIt.call()));
  getIt.registerLazySingleton(() => HistoryService(dioClient: getIt.call(), logger: getIt.call()));
  getIt.registerLazySingleton(() => AhtoneLevelService(dioClient: getIt.call(), logger: getIt.call()));
  getIt.registerLazySingleton(() => SpicyLevelService(dioClient: getIt.call(), logger: getIt.call()));
  getIt.registerLazySingleton(() => MenuService(dioClient: getIt.call(), logger: getIt.call()));
  getIt.registerLazySingleton(() => ReportService(dioClient: getIt.call(), logger: getIt.call()));
  getIt.registerLazySingleton(() => LocalNotificationService());

  //base api
  getIt.registerLazySingleton(() => DioClient(sharedPref: getIt.call(), dio: getIt.call()));

  //shared pref
  getIt.registerLazySingleton(() => SharedPref());

  getIt.registerLazySingleton(() => CustomLogger(logger: getIt.call()));

  getIt.registerLazySingleton(() => Logger());

  /// Dio
  getIt.registerLazySingleton(() {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.BASE_URL_DEV,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
    return dio;
  });
}

