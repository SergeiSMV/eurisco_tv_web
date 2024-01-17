


import 'package:flutter/material.dart';

import '../../colors.dart';

Widget settingsAppBar(String deviceID, String deviceName, String contentName, String previewLink){

  String deviceHint = deviceID == 'общая настройка' ? deviceID : 'id: $deviceID';
  String nameHint = deviceName == 'для всех устройств' ? deviceName : 'имя: $deviceName';

  return PreferredSize(
    preferredSize: const Size.fromHeight(60.0),
    child: SliverAppBar(
      elevation: 0,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFFe3efff),
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.only(start: 0, bottom: 5),
        expandedTitleScale: 1,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFe3efff).withOpacity(0.8),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(contentName, style: firm13, overflow: TextOverflow.ellipsis),
                  Text(deviceHint, style: firm13, overflow: TextOverflow.ellipsis),
                  Text(nameHint, style: firm13, overflow: TextOverflow.ellipsis),
                ],
              ),
            )
          ),
        ),
        background: Image.network(
          previewLink,
          fit: BoxFit.cover,
        ),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(20.0),
        child: SizedBox(height: 5,),
      ),
    ),
  );
}