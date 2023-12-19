import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hote_management/models/user_models.dart';
import 'package:hote_management/services/storage_services.dart';
import 'package:hote_management/ui/dashboard/Tabs/dashboard/dashboard_screen.dart';
import 'package:hote_management/ui/dashboard/Tabs/dashboard/dashboard_view_model.dart';
import 'package:hote_management/ui/statistics/statistics_view_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../config/app_toast.dart';
import '../../enum/user_roles.dart';
import '../../log/app_log.dart';
import '../../services/http_services.dart';
import '../statistics/statistics_screen.dart';
import 'Tabs/help/help_screen.dart';
import 'Tabs/settings/setting_screen.dart';
import 'Tabs/user/user_screen.dart';
import 'components/custom_header.dart';

class MainScreen extends StatefulWidget {

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {

  Future<UserModels?>? loggedInUserModel;

  late TabController tabController;
  List<String> tabList = ["Dashboard", "Reports", "Users", "Help", "Settings"];

  List<Widget> tabWidgets(UserModels userModels) {
    List<Widget> temporaryValue = [];

    temporaryValue.add(DashboardScreen(userModels: userModels));
    temporaryValue.add(const SizedBox());
    if (userModels.roles != UserRoles.staff.name) {
      temporaryValue.add(const UserScreen());
    }
    temporaryValue.add(HelpScreen(userRoles: userModels.roles.userRoles));
    temporaryValue.add(SettingScreen(userRoles: userModels.roles.userRoles));
    return temporaryValue;
  }

  bool useLoader = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      loggedInUserModel = StorageServices.user;
      final userModel = await StorageServices.user;
      if (userModel != null) {
        if (userModel.roles == UserRoles.staff.name) {
          tabList.remove('Users');
        }
        if (!mounted) return;
        setState(() {});
      }
    });
    tabController = TabController(length: tabList.length, vsync: this);
    Future.microtask(() {
      context.read<StatisticsViewModel>().firebaseConversationIdWiseChat(context);
      context.read<StatisticsViewModel>().firebaseStatisticsGroupChat();
      context.read<StatisticsViewModel>().firebaseStatisticsIsOnlineUser();
      context.read<StatisticsViewModel>().firebaseStatisticsNotification();
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Dashboard',
      color: Colors.white,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(191, 191, 191, 1),
        body: FutureBuilder<UserModels?>(
          future: StorageServices.user,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            }
            final user = snapshot.data!;
            return ModalProgressHUD(
              inAsyncCall: useLoader,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  CustomHeader(
                    controller: tabController,
                    loggedUserName: '${user.name} ${user.surname}',
                    tabList: tabList,
                    onTabChanged: (int value) {
                      if (!mounted) return;
                      setState(() {});
                    },
                    onLogoutPressed: () => onUserLogout(user)
                  ),

                  Container(
                    color: const Color.fromRGBO(191, 191, 191, 1),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(
                          width: 1.0.sw > 1024 ? 0.8.sw : 1.0.sw,
                          child: tabWidgets(user)[tabController.index]
                        ),

                        if (1.0.sw > 1024)
                          Flexible(
                            child: Container(
                              width: 0.2.sw,
                              margin: EdgeInsets.only(top: 2.h, right: 2.w),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                shape: BoxShape.rectangle,
                                color: Colors.white
                              ),
                              height: MediaQuery.of(context).size.height * 0.906,
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              child: const DashboardStatistics(),
                            ),
                          ),

                      ],
                    ),
                  )

                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> onUserLogout(UserModels userModels) async {
    if (!mounted) return;
    setState(() {
      useLoader = true;
    });
    try {
      final fetchResult = await putRequest('user/logout', context: context);
      if (fetchResult != null) {
        AppToast.showToastMsg('${userModels.name} ${userModels.surname} has been logout successfully.', bgColor: Colors.green.shade600);
        if (!mounted) return;
        context.read<DashboardTabModel>().resetActiveTabValues();
        Router.neglect(context, () {
          context.go('/');
        });
      } else {
        AppToast.showToastMsg('Something went wrong', bgColor: Colors.red.shade600);
      }

    } catch (e) {
      AppLog.e(e, 'MainScreen', methodName: 'onUserLogout', message: e.toString());
    }
    if (!mounted) return;
    setState(() {
      useLoader = false;
    });
  }
}