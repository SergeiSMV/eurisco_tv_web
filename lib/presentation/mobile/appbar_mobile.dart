import 'package:flutter/material.dart';

import '../../colors.dart';

PreferredSizeWidget appbarMobile(BuildContext context, String deviceID, String deviceName){
  return AppBar(
    titleSpacing: 0,
    iconTheme: IconThemeData(color: firmColor),
    backgroundColor: const Color(0xFFe3efff),
    elevation: 0,
    title: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('id: $deviceID', style: darkFirm14,),
        Text('имя: $deviceName', style: darkFirm13,),
      ],
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: IconButton(
          onPressed: (){  }, 
          icon: const Icon(
            Icons.edit, 
            color: Color(0xFF96a0b7), 
            size: 20,
          ),
          splashRadius: 15,
        ),
      )
    ],
  );
}