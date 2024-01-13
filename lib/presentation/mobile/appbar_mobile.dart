import 'package:flutter/material.dart';

import '../../colors.dart';
import 'rename_device.dart';

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