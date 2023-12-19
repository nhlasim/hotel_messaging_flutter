import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hote_management/enum/user_roles.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../../components/custom_elevated_btn.dart';
import 'help_view_model.dart';
import 'sub_module/create_help_view.dart';
import 'sub_module/show_help_view.dart';

class HelpScreen extends StatefulWidget {

  final UserRoles userRoles;

  const HelpScreen({super.key, required this.userRoles});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HelpViewModel>().showAllHelp(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HelpViewModel>(
      builder: (context, helpVM, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
          width: 0.75.sw,
          height: 0.91.sh,
          child: ModalProgressHUD(
            inAsyncCall: helpVM.useLoader,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  height: 120.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    border: Border.all(color: Colors.black)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      SizedBox(
                        height: 34.h,
                        child: Container(
                          width: 120.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.w),
                            border: Border.all(color: Colors.grey.withOpacity(0.4))
                          ),
                          child: TextField(
                            controller: helpVM.searchController,
                            onChanged: (String value) => helpVM.onSearchHelp(value),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2.w),
                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2.w),
                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2.w),
                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                              hintText: 'Type item to search',
                              alignLabelWithHint: true,
                              hintStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.withOpacity(0.4)
                              ),
                              isDense: true
                            ),
                            textAlign: TextAlign.start,
                            textInputAction: TextInputAction.search,
                            textCapitalization: TextCapitalization.none,
                            enableSuggestions: true,
                            enableInteractiveSelection: true,
                            enableIMEPersonalizedLearning: true,
                            enabled: true,
                            autocorrect: true,
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h,),

                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [

                          SizedBox(
                            height: 35.h,
                            child: CustomElevatedButton(
                              btnLabel: 'Show All',
                              btnBorderRadius: BorderRadius.circular(2.w),
                              onBtnPressed: () => helpVM.showAllHelp(context),
                            ),
                          ),

                          if (widget.userRoles == UserRoles.admin || widget.userRoles == UserRoles.super_user) ... {
                            SizedBox(width: 6.w,),

                            SizedBox(
                              height: 35.h,
                              width: 40.w,
                              child: CustomElevatedButton(
                                btnLabel: 'Create Help Item',
                                btnBorderRadius: BorderRadius.circular(2.w),
                                onBtnPressed: helpVM.onCreateHelpItem,
                              ),
                            ),
                          }

                        ],
                      ),

                    ],
                  ),
                ),

                SizedBox(height: 4.h,),

                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      border: Border.all(color: Colors.black)
                    ),
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 12.h),
                    child: helpVM.showCreateHelpItem
                    ? CreateHelpView(helpViewModel: helpVM,)
                    : ShowHelpView(helpViewModel: helpVM),
                  ),
                )

              ],
            ),
          ),
        );
      }
    );
  }
}