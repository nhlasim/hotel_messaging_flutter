import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hote_management/config/app_route.dart';
import 'package:hote_management/ui/dashboard/Tabs/dashboard/dashboard_view_model.dart';
import 'package:hote_management/ui/dashboard/Tabs/help/help_view_model.dart';
import 'package:hote_management/ui/statistics/statistics_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'services/storage_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  StorageServices.initPrefs();
  setPathUrlStrategy();
  FirebaseApp firebaseApp = await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instanceFor(app: firebaseApp);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => HelpViewModel(),
      ),
      ChangeNotifierProvider(
        create: (_) => DashboardTabModel(null),
      ),
      ChangeNotifierProvider(
        create: (_) => StatisticsViewModel(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Hotel Management',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          debugShowMaterialGrid: false,
          routerConfig: AppRoute.router,
        );
      },
    );
  }
}