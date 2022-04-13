import 'package:flutter/material.dart';
import 'package:mobile/pages/home/home_bloc.dart';
import 'package:mobile/pages/home/home_page.dart';
import 'package:mobile/pages/login/login_bloc.dart';
import 'package:mobile/pages/login/login_page.dart';
import 'package:mobile/pages/navigation/navigation_page.dart';
import 'package:mobile/pages/splash/splash_bloc.dart';
import 'package:mobile/routers/screen_arguments.dart';

import '../base/base_bloc.dart';
import '../pages/history/detail_order_page.dart';
import '../pages/splash/splash_page.dart';
import '../widgets/webview_page.dart';
import 'slide_left_route.dart';

class CustomRouter {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    late ScreenArguments arg;
    final Object? arguments = settings.arguments;
    if (arguments != null) {
      arg = arguments as ScreenArguments;
    }
    switch (settings.name) {
      case SplashPage.routeName:
        return SlideLeftRoute(BlocProvider(
          bloc: SplashBloc(),
          child: const SplashPage(),
        ));
      case NavigationPage.routeName:
        return SlideLeftRoute(const NavigationPage());
      case LoginPage.routeName:
        return SlideLeftRoute(BlocProvider(
          bloc: LoginBloc(),
          child: const LoginPage(),
        ));
      case WebViewPage.routeName:
        return SlideLeftRoute(WebViewPage(arguments: arg));
      case DetailOrderPage.routeName:
        return SlideLeftRoute(DetailOrderPage(arguments: arg));
      default:
        throw ('this route name does not exist');
    }
  }
}
