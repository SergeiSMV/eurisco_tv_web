import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import '../../colors.dart';
import '../../data/server_implementation.dart';
import '../../globals.dart';

PreferredSizeWidget appbarMobile(BuildContext context, String deviceID, String deviceName){
  String deviceHint = deviceID == 'общая настройка' ? '' : 'id: ';
  String nameHint = deviceName == 'для всех устройств' ? '' : 'имя: ';
  final progress = ProgressHUD.of(context);
  final messenger = ScaffoldMessenger.of(context);
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
          onPressed: (){  }, 
          icon: const Icon(
            Icons.edit, 
            color: Color(0xFF53607b), 
            size: 23,
          ),
          splashRadius: 15, 
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: IconButton(
          onPressed: () async { 
            List<String> allowedExtensions = ['mp4', 'jpg', 'jpeg'];
            FilePickerResult? picked = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: allowedExtensions, allowMultiple: false, withData: true);
            if (picked != null) {
              String extention = picked.names[0].toString().split('.')[1];
              log.d('extention: $extention');
              progress?.showWithText('гномы потащили\nфайл на сервер');
              String result = allowedExtensions.contains(extention) ? await ServerImpl().uploadFile(picked) : 'failed';
              if (result == 'done'){
                progress?.dismiss();
                messenger._toast('файл успешно загружен');
                // return ref.refresh(getWebConfigProvider);
              } else if (result == 'failed') {
                progress?.dismiss();
                messenger._toast('недопустимый формат файла .$extention\nвыбирете файл соответствующий одному из следующих форматов: mp4, jpg, jpeg');
              } else {
                progress?.dismiss();
                messenger._toast('ошибка загрузки');
              }
            }
          }, 
          icon: const Icon(
            Icons.video_call_rounded, 
            color: Color(0xFF53607b),
            size: 24,
          ),
          splashRadius: 15,
        ),
      )
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