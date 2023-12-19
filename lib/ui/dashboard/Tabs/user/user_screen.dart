import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hote_management/components/custom_chip.dart';
import 'package:hote_management/enum/user_roles.dart';
import 'package:hote_management/log/app_log.dart';
import 'package:hote_management/models/user_models.dart';
import 'package:hote_management/ui/dashboard/Tabs/user/sub_module/create_user_view.dart';
import 'package:hote_management/ui/dashboard/Tabs/user/sub_module/deactivate_user_view.dart';
import 'package:hote_management/ui/dashboard/Tabs/user/sub_module/delete_user_view.dart';
import 'package:hote_management/ui/dashboard/Tabs/user/user_view_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

import '../../../../services/http_services.dart';
import '../../../../services/storage_services.dart';

class UserScreen extends StatefulWidget {

  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  UserModels? loginUserModels;
  UserRoles? userRoles;

  List<UserModels> originalUserModels = [];
  List<UserModels> searchUserModels = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      loginUserModels = await StorageServices.user;
      if (loginUserModels != null) {
        userRoles = loginUserModels!.roles.userRoles;
        AppLog.d('User Screen', message: 'user role: $userRoles');
        _updateState();
      }
    });
    onSearchUser();
  }

  void _updateState() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (userRoles == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListenableProvider<UserViewModel>(
      create: (_) => UserViewModel(),
      lazy: true,
      builder: (_, child) {
        final userViewModel = _.watch<UserViewModel>();
        if (userRoles == UserRoles.manager) {
          userViewModel.userStats.remove('Delete');
        }
        return SizedBox(
          height: 0.92.sh,
          child: ModalProgressHUD(
            inAsyncCall: userViewModel.useLoader,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      height: 60.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        border: Border.all(color: Colors.black)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(color: Colors.grey.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            width: 120.w,
                            child: Row(
                              children: [

                                Flexible(
                                  child: SearchField<UserModels>(
                                    inputType: TextInputType.text,
                                    textInputAction: TextInputAction.search,
                                    textCapitalization: TextCapitalization.none,
                                    enabled: true,
                                    controller: userViewModel.searchController,
                                    hint: 'Type name, surname or username',
                                    autoCorrect: true,
                                    maxSuggestionsInViewPort: 6,
                                    suggestionState: Suggestion.hidden,
                                    suggestionDirection: SuggestionDirection.down,
                                    onSuggestionTap: (SearchFieldListItem<UserModels> value) {
                                      userViewModel.onSelectUserFromSearch(value.item!);
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      FocusScope.of(context).unfocus();
                                    },
                                    itemHeight: 45.h,
                                    onSearchTextChanged: (query) {
                                      if (query.trim().isEmpty) {
                                        return [];
                                      }
                                      searchUserModels = originalUserModels.where((element) {
                                        bool value = true;
                                        if (userRoles == UserRoles.super_user) {
                                          value = element.roles.userRoles != UserRoles.admin;
                                        } else if (userRoles == UserRoles.manager) {
                                          value = element.roles.userRoles == UserRoles.staff && element.managerDetails!.id == loginUserModels!.id;
                                        }
                                        return value && element.deletedAt == null && (element.name.toLowerCase().contains(query.toLowerCase())
                                        || element.surname.toLowerCase().contains(query.toLowerCase())
                                        || element.emailId.toLowerCase().contains(query.toLowerCase()));
                                      }).toList();
                                      return searchUserModels.map((e) {
                                        return SearchFieldListItem<UserModels>(
                                          e.name,
                                          item: e,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                Text(
                                                  e.name,
                                                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                                                ),

                                                Text(
                                                  'Role: ${e.roles.userRoles.enumToString}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        );
                                      }).toList();
                                    },
                                    suggestionAction: SuggestionAction.next,
                                    searchInputDecoration: InputDecoration(
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
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                                      hintText: 'Type name, surname or username',
                                      alignLabelWithHint: true,
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.withOpacity(0.4)
                                      ),
                                    ),
                                    suggestions: const [],
                                  ),
                                ),

                                SizedBox(
                                  width: 10.w,
                                  child: Icon(
                                    Icons.search_rounded,
                                    color: Colors.grey,
                                    size: 6.w,
                                  ),
                                ),

                              ],
                            ),
                          ),

                          Container(
                            width: 100.w,
                            height: 50.h,
                            alignment: Alignment.centerRight,
                            child: CustomChip<String>(
                              items: userViewModel.userStats,
                              chipTextFontSize: 12,
                              sizePerItems: 24.w,
                              onValueSelected: (String value) {
                                userViewModel.onUserStatsChanged(value);
                              },
                              selectedItem: userViewModel.selectedUserStats
                            ),
                          )

                        ],
                      ),
                    ),

                    SizedBox(height: 4.h,),

                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        border: Border.all(color: Colors.black)
                      ),
                      height: 0.815.sh,
                      child: userViewModel.selectedUserStats == 'Create'
                      ? CreateUserView(userViewModel: userViewModel, userRoles: userRoles!,)
                      : userViewModel.selectedUserStats == 'Deactivate'
                      ? DeactivateUserView(
                        userRoles: userRoles!,
                        userViewModel: userViewModel,
                        updateUserSearch: () => onSearchUser(),
                      )
                      : DeleteUserView(
                        userRoles: userRoles!,
                        userViewModel: userViewModel,
                        updateUserSearch: () => onSearchUser(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> onSearchUser() async {
    final fetchResult = await getRequest('user/search-user');
    if (fetchResult != null) {
      originalUserModels = (fetchResult as List<dynamic>).map((e) => UserModels.fromJson(e)).toList();
      searchUserModels = originalUserModels;
      _updateState();
    }
  }
}
