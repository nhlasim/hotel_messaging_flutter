import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hote_management/config/app_assets.dart';

import '../../../config/app_color.dart';
import '../../../config/constants.dart';

class CustomHeader extends StatelessWidget {

  const CustomHeader({
    super.key,
    required this.controller,
    required this.tabList,
    required this.onTabChanged,
    required this.loggedUserName,
    required this.onLogoutPressed
  });

  final TabController controller;
  final List tabList;
  final ValueChanged<int> onTabChanged;
  final String loggedUserName;
  final VoidCallback onLogoutPressed;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      color: AppColors.homeHeaderColor,
      width: size.width,
      height: AppBar.preferredHeightFor(context, Size(size.width, size.height * 0.08)),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                Text(
                  ConstantStrings.appname,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 30.sp,
                    color: Colors.white
                  )
                ),

                SizedBox(width: 0.04.sw,),

                SizedBox(
                  width: 0.5.sw,
                  child: TabBar(
                    isScrollable: false,
                    controller: controller,
                    labelColor: Colors.black,
                    mouseCursor: MouseCursor.uncontrolled,
                    unselectedLabelColor: Colors.white,
                    indicator: const BoxDecoration(color: Colors.white),
                    tabs: tabList.map((e) => Tab(text: e)).toList(),
                    onTap: (int value) => onTabChanged(value),
                  ),
                )

                ],
              )
          ),

          SizedBox(
            width: 0.19.sw,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AppAssets.profile,
                        color: Colors.white,
                      ),

                      SizedBox(width: 0.01.sw,),

                      Text(
                        loggedUserName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(width: 12.w,),

                GestureDetector(
                  onTap: onLogoutPressed,
                  child: Image.asset(
                    AppAssets.logoutIMG,
                    color: Colors.white,
                    fit: BoxFit.fill,
                    height: 28.h,
                  ),
                )

              ],
            ),
          ),

        ],
      ),
    );
  }
}