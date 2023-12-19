import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hote_management/ui/dashboard/Tabs/dashboard/dashboard_view_model.dart';
import 'package:hote_management/ui/dashboard/Tabs/dashboard/sub_module/active/chat_conversation_view.dart';

import '../../../../../../config/app_color.dart';

class ConversationView extends StatelessWidget {

  final DashboardTabModel dashboardTabModel;

  const ConversationView({super.key, required this.dashboardTabModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [

        Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(color: Colors.black),
            color: AppColors.lavenderBlue
          ),
          height: 50.h,
          alignment: Alignment.centerLeft,
          width: 1.0.sw,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: const Text(
            'Messages to Send (0)',
            style: TextStyle(
              color: Colors.black,
              fontSize: 12.0,
              fontWeight: FontWeight.w600
            ),
          ),
        ),

        Expanded(
          child: dashboardTabModel.selectedScheduleReservationFromActive == null
          ? Container(
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black)
            ),
            child: Text(
              "No Active Conversations",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500
              ),
            )
          )
          : ChatConversationView(dashboardTabModel: dashboardTabModel)
        ),

      ],
    );
  }
}

// GestureDetector(
//   onTap: ()async{
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colors.grey.shade400,
//           title: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("Digital Assets",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold,color: Colors.black)),
//
//                   IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.close))
//                 ],
//               ),
//
//               Divider(thickness: 1,color: Colors.black),
//             ],
//           ),
//           content:Container(
//             width: MediaQuery.of(context).size.width.w,
//             height:400.h,
//             color: Colors.blue,
//             margin: EdgeInsets.all(3.w),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                Container(height: 50.h,width: 293.w, color: Colors.amber),
//                Container(height: 50.h,width: 193.w,color: Colors.blueGrey)
//               ],
//             ),
//           ),
//         );
//       }
//     );
//     // FilePickerResult? result = await FilePicker.platform.pickFiles(
//     //   type: FileType.custom,
//     //   allowMultiple: false,
//     //   allowedExtensions: ['jpg', 'pdf','png','jpeg'],
//     // );
//
//     // if (result != null) {
//     //   debugPrint("File Picker :: ${result.files} \n ${result.names} \n ${result.paths}");
//     // }
//   },
//   child: Padding(
//     padding: EdgeInsets.symmetric(horizontal: 6.0.w,vertical: 3.0.h),
//     child: Row(
//       mainAxisSize: MainAxisSize.max,
//       children: [
//
//         Image.asset(
//           AppAssets.attachment,
//           height: 5.w,
//           width: 5.w,
//         ),
//
//         SizedBox(width: 2.w,),
//
//         Text(
//           'Attach File',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w600
//           ),
//         ),
//       ],
//     ),
//   ),
// ),


