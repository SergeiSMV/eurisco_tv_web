import 'package:flutter/material.dart';

import '../colors.dart';
import '../globals.dart';
import 'mobile/rename_device.dart';

PreferredSizeWidget appbar(BuildContext context, String deviceID, String deviceName){
  String deviceHint = deviceID == 'общая настройка' ? '' : 'id: ';
  String nameHint = deviceName == 'для всех устройств' ? '' : 'имя: ';
  double screenWidth = MediaQuery.of(context).size.width;
  return AppBar(
    titleSpacing: 0,
    iconTheme: IconThemeData(color: firmColor),
    backgroundColor: const Color(0xFFe3efff),
    elevation: 0,
    title: 
    Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$deviceHint$deviceID', style: darkFirm14,),
            Text('$nameHint$deviceName', style: darkFirm13,),
          ],
        ),
        const SizedBox(width: 20),
        screenWidth < screenWidthParam ? const SizedBox.shrink() :
          deviceID == 'общая настройка' ? const SizedBox.shrink() :
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
    actions: 
    screenWidth > screenWidthParam ? [] :
    [
      deviceID == 'общая настройка' ? const SizedBox.shrink() :
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

extension on ScaffoldMessengerState {
  // ignore: unused_element
  void _toast(String message){
    showSnackBar(
      SnackBar(
        content: Text(message), 
        duration: const Duration(seconds: 5),
      )
    );
  }
}