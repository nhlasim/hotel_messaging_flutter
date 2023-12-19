import 'package:flutter/material.dart';
import 'package:hote_management/enum/user_roles.dart';
import 'package:hote_management/models/group_chat_models.dart';
import 'package:intl/intl.dart';

class GroupChatItemView extends StatelessWidget {

  final int index;
  final Map<DateTime, List<GroupChatModels>> groupChatModels;

  const GroupChatItemView({super.key, required this.groupChatModels, required this.index});

  @override
  Widget build(BuildContext context) {
    final keysList = groupChatModels.keys.toList();
    final keysItems = keysList[index];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Container(
          height: 35.0,
          alignment: Alignment.center,
          child: Text(
            DateFormat('dd MMMM yyyy').format(keysItems),
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue.shade800,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        Flexible(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: groupChatModels[keysItems]!.length,
            itemBuilder: (context, subIndex) {
              final groupChatItem = groupChatModels[keysItems]![subIndex];
              final userName = '${groupChatItem.userModels.name} (${groupChatItem.userModels.roles.userRoles.enumToString}) : ';
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text.rich(
                  TextSpan(
                    text: userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      fontSize: 12.0
                    ),
                    children: [
                      TextSpan(
                        text: groupChatItem.message,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 12.0
                        ),
                      )
                    ]
                  )
                ),
              );
            },
          ),
        )

      ],
    );
  }
}
