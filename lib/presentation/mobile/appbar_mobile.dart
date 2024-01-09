import 'package:flutter/material.dart';

import '../../colors.dart';

PreferredSizeWidget appbarMobile(BuildContext context, String deviceID, String deviceName){
  String deviceHint = deviceID == 'общая настройка' ? '' : 'id: ';
  String nameHint = deviceName == 'для всех устройств' ? '' : 'имя: ';
  return AppBar(
    titleSpacing: 0,
    iconTheme: IconThemeData(color: firmColor),
    backgroundColor: const Color(0xFFe3efff),
    elevation: 0,
    title: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$deviceHint$deviceID', style: darkFirm14,),
        Text('$nameHint$deviceName', style: darkFirm13,),
      ],
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: IconButton(
          onPressed: (){  }, 
          icon: const Icon(
            Icons.edit, 
            color: Color(0xFF53607b), 
            // color: darkFirmColor, 
            size: 23,
          ),
          splashRadius: 15, 
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: IconButton(
          onPressed: (){  }, 
          icon: const Icon(
            Icons.video_call_rounded, 
            color: Color(0xFF53607b), 
            // color: darkFirmColor,
            size: 24,
          ),
          splashRadius: 15,
        ),
      )
    ],
  );
}