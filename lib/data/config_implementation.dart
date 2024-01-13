import 'dart:collection';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:eurisco_tv_web/data/server_implementation.dart';
import 'package:file_picker/file_picker.dart';

import '../domain/config_repository.dart';
import '../globals.dart';

class ConfigImpl extends ConfigRepository{
  
  // добавление глобальных настроек
  @override
  Map addGlobalSettings(Map config) {
    Map template = config[config.keys.toList().first]['content'];
    Map global = {
      "content": template,
      "name": "для всех устройств"
    };
    Map newConfig = LinkedHashMap.from({'общая настройка': global, ...config});
    return newConfig;
  }

  // загрузка файла
  @override
  Future<String> uploadFile() async {
    FilePickerResult? picked = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: allowedExtensions, allowMultiple: false, withData: true);
    String message;

    if (picked != null) {
      Uint8List fileBytes = picked.files.first.bytes!;
      String fileName = picked.files.first.name;
      String extention = picked.names[0].toString().split('.')[1];
      String allowedExtensionsString = allowedExtensions.toString().replaceAll('[', '').replaceAll(']', '');

      FormData formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
      });

      if(allowedExtensions.contains(extention)){
        String responce = await ServerImpl().sendFileToServer(formData);
        responce == 'done' ? 
          message = 'Файл успешно загружен' :
          message = 'Ошибка загрузки';
      } else {
        message = 'Недопустимый формат файла!\nВыбирете файл соответствующий одному из следующих форматов: $allowedExtensionsString';
      }
    } else {
      message = 'Отмена';
    }
    return message;
  }

}