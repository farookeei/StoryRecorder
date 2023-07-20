import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared/data/network_client/dio_client.dart';
import '../../themes/theme.dart';
import '../routes/routes.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return MultiBlocProvider(
    //   providers: const [],
    //   child: AppView(),
    // );

    return AppView();
  }
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class AppView extends StatefulWidget {
  AppView({
    Key? key,
  }) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final _router;
  final DioClient _dio = DioClient();

  @override
  void initState() {
    _router = AppRouter();

    super.initState();
  }

  @override
  void dispose() {
    _router.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        splitScreenMode: true,
        minTextAdapt: true,
        designSize: const Size(360, 800),
        builder: (ctx, _) {
          return MaterialApp(
            navigatorObservers: [routeObserver],
            //navigatorKey: GlobalVariable.navState,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            // darkTheme: AppTheme.dark,
            title: 'Video Record',
            // locale: DevicePreview.locale(context),
            // builder: DevicePreview.appBuilder,
            onGenerateRoute: _router.onGenerateRoute,
          );

          // return GestureDetector(
          //   onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          //   child: MaterialApp(
          //     title: 'get superr',
          //     onGenerateRoute: (RouteSettings settings) {
          //       switch (settings.name) {
          //         case '/':
          //           return MaterialWithModalsPageRoute(
          //               builder: (_) => MyHomePage(), settings: settings);
          //       }
          //     },
          //     localizationsDelegates: const [
          //       GlobalMaterialLocalizations.delegate,
          //       GlobalWidgetsLocalizations.delegate,
          //     ],
          //     supportedLocales: const [
          //       Locale('en'),
          //       Locale('zh'),
          //       Locale('fr'),
          //       Locale('es'),
          //       Locale('de'),
          //       Locale('ru'),
          //       Locale('ja'),
          //       Locale('ar'),
          //       Locale('fa'),
          //       Locale("es"),
          //     ],
          //     theme: ThemeData(
          //         primarySwatch: Colors.indigo, accentColor: Colors.pinkAccent),
          //   ),
          // );
        });

    //  MaterialApp(
    //   home: FlowBuilder<AppStatus>(
    //     state: context.select((AppBloc bloc) => bloc.state.status),
    //     onGeneratePages: onGenerateAppViewPages,
    //   ),
    // );
  }
}
