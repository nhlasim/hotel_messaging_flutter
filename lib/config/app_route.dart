import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hote_management/ui/password/password_screen.dart';

import '../ui/dashboard/main_screen.dart';
import '../ui/login/login_screen.dart';

class AppRoute {

  static GoRouter router = GoRouter(
    initialLocation: '/',
    routerNeglect: true,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/new-password-generation',
        name: 'new-password-generation',
        builder: (BuildContext context, GoRouterState state) {
          return PasswordScreen(token: state.queryParams['token'] as String);
        },
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (BuildContext context, GoRouterState state) {
          return const MainScreen();
        },
      ),
    ],
  );

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    Widget? routeWidget;
    Object? args = routeSettings.arguments;
    if (routeSettings.name == '/') {
      routeWidget = const LoginScreen();
    } else if (routeSettings.name == '/dashboard') {
      routeWidget = const MainScreen();
    } else if(routeSettings.name =="/startConvarsation") {
      //routeWidget = const StartConversationScreen();
    } else if (routeSettings.name == '/new-password-generation') {
      routeWidget = PasswordScreen(token: args as String);
    } else {
      throw Exception('No Route Found for : ${routeSettings.name}');
    }
    return MaterialPageRoute(builder: (context) {
      return routeWidget!;
    }, settings: routeSettings, allowSnapshotting: false);
  }

}