import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/app_color.dart';
import '../help_view_model.dart';

class ShowHelpView extends StatelessWidget {

  final HelpViewModel helpViewModel;

  const ShowHelpView({super.key, required this.helpViewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          'Frequently Asked Questions',
          style: TextStyle(
            color: AppColors.homeHeaderColor,
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
        ),

        SizedBox(height: 24.h,),

        Flexible(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: helpViewModel.searchHelpModels?.length ?? 0,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            separatorBuilder: (context, index) => SizedBox(height: 18.h,),
            itemBuilder: (context, index) {

              if (helpViewModel.searchHelpModels == null) {
                return const SizedBox.shrink();
              }

              final helpItem = helpViewModel.searchHelpModels![index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    helpItem.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black
                    ),
                  ),

                  SizedBox(height: 4.h,),

                  Text(
                    helpItem.description,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black
                    ),
                  ),

                ],
              );
            },
          ),
        )
      ],
    );
  }
}