import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hote_management/components/input_field_with_header.dart';
import 'package:hote_management/config/app_assets.dart';

import '../../../../../components/custom_elevated_btn.dart';
import '../../../../../config/app_color.dart';
import '../help_view_model.dart';

class CreateHelpView extends StatelessWidget {

  final HelpViewModel helpViewModel;

  const CreateHelpView({super.key, required this.helpViewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          'Create Help Item',
          style: TextStyle(
            color: AppColors.homeHeaderColor,
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
        ),

        SizedBox(height: 24.h,),

        InputFieldWithHeader(
          editingController: helpViewModel.titleController,
          headerLabel: 'Title',
          inputHint: 'Type title of help item',
        ),

        SizedBox(height: 24.h,),

        InputFieldWithHeader(
          editingController: helpViewModel.descriptionController,
          headerLabel: 'Description',
          inputHint: 'Describe solution and add any attachment by pressing attachment icon below.',
          inputAction: TextInputAction.newline,
          maximumLines: 6,
          useInfinityWidth: true,
        ),

        SizedBox(height: 24.h,),

        GestureDetector(
          onTap: () => helpViewModel.pickFiles(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [

              Image.asset(
                AppAssets.attachment,
                height: 4.w,
                width: 4.w,
              ),

              SizedBox(width: 2.w,),

              const Text(
                'Attach File',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600
                ),
              ),

            ],
          ),
        ),

        SizedBox(height: 24.h,),

        SizedBox(
          height: 40.h,
          child: CustomElevatedButton(
            btnLabel: 'Submit',
            btnBorderRadius: BorderRadius.circular(2.w),
            onBtnPressed: () => helpViewModel.createHelp(context),
          ),
        ),

      ],
    );
  }
}