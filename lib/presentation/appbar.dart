import 'package:flutter/material.dart';

import '../colors.dart';
import '../globals.dart';
import 'rename_device.dart';

PreferredSizeWidget appbar(BuildContext context, String deviceID, String deviceName){

  double screenWidth = MediaQuery.of(context).size.width;
  
  return AppBar(
    titleSpacing: 0,
    iconTheme: IconThemeData(color: firmColor),
    backgroundColor: const Color(0xFFe3efff),
    elevation: 0,
    title: Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('id: $deviceID', style: darkFirm14,),
            Text('имя: $deviceName', style: darkFirm13,),
          ],
        ),
        const SizedBox(width: 20),
        screenWidth < screenWidthParam ? const SizedBox.shrink() :
        IconButton(
          onPressed: (){
            renameDevice(context, deviceID);
          }, 
          icon: const Icon(
            Icons.edit, 
            color: Color(0xFF53607b), 
            size: 23,
          ),
          splashRadius: 15, 
        ),
      ],
    ),
    actions: screenWidth > screenWidthParam ? [] :
    [
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: IconButton(
          onPressed: (){
            renameDevice(context, deviceID);
          }, 
          icon: const Icon(
            Icons.edit, 
            color: Color(0xFF53607b), 
            size: 23,
          ),
          splashRadius: 15, 
        ),
      ),
    ],
  );
}