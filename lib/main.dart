import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/htone_level_cubit/htone_level_cubit.dart';
import 'package:shan_shan/controller/auth_cubit/auth_cubit.dart';
import 'package:shan_shan/controller/edit_sale_cart_cubit/edit_sale_cart_cubit.dart';
import 'package:shan_shan/controller/internet_cubit/internet_connection_cubit.dart';
import 'package:shan_shan/controller/sale_report_cubit/sale_report_cubit.dart';
import 'package:shan_shan/controller/spicy_level_crud_cubit/spicy_level_cubit.dart';
import 'package:shan_shan/controller/theme_cubit/theme_cubit.dart';
import 'package:shan_shan/core/utils/navigation_helper.dart';
import 'package:shan_shan/injection_container.dart' as ic;
import 'package:shan_shan/controller/menu_cubit/menu_cubit.dart';
import 'package:shan_shan/controller/cart_cubit/cart_cubit.dart';
import 'package:shan_shan/controller/category_cubit/category_cubit.dart';
import 'package:shan_shan/controller/products_cubit/products_cubit.dart';
import 'package:shan_shan/controller/sale_process_cubit/sale_process_cubit.dart';
import 'package:shan_shan/controller/sales_history_cubit/sales_history_cubit.dart';
import 'package:shan_shan/view/home/home.dart';
import 'package:shan_shan/view/auth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  ic.primaryInit();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final bool isLogin = true;
  bool? isShow;
  bool openApp = false;
  bool? testingValue;
  String errorReason = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ic.getIt<InternetConnectionCubit>()),
        BlocProvider(create: (context) => ic.getIt<ThemeCubit>()),
        BlocProvider(create: (context) => ic.getIt<AuthCubit>()..checkLoginStatus()),
        BlocProvider(create: (context) => ic.getIt<CartCubit>()),
        BlocProvider(create: (context) => ic.getIt<ProductsCubit>()),
        BlocProvider(create: (context) => ic.getIt<CategoryCubit>()),
        BlocProvider(create: (context) => ic.getIt<MenuCubit>()),
        BlocProvider(create: (context) => ic.getIt<SaleProcessCubit>()),
        BlocProvider(create: (context) => ic.getIt<SalesHistoryCubit>()),
        BlocProvider(create: (context) => ic.getIt<CategoryCubit>()),
        BlocProvider(create: (context) => ic.getIt<HtoneLevelCubit>()),
        BlocProvider(create: (context) => ic.getIt<SpicyLevelCubit>()),
        BlocProvider(create: (context) => ic.getIt<SaleReportCubit>()),
        BlocProvider(create: (context) => ic.getIt<EditSaleCartCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'ShanShan',
            theme: state.theme,
            debugShowCheckedModeBanner: false,
            home: App(),
          );
        },
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ShopLoggedInState) {
          Future.delayed(Duration(milliseconds: 100), () {
            if (!context.mounted) return;
            NavigationHelper.pushReplacement(context, HomeScreen());
          });
        } else {
          Future.delayed(
            Duration(milliseconds: 100),
            () {
              if (!context.mounted) return;
              NavigationHelper.pushReplacement(context, Login());
            },
          );
        }
      },
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: Center(
            child: SizedBox(
              height: 200,
              width: 200,
              child: Image.asset("assets/images/cashier.png"),
            ),
          ),
        );
      },
    );
  }
}
