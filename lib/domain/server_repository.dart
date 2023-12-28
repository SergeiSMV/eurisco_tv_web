import 'package:file_picker/file_picker.dart';

abstract class ServerRepository{

  // ручная авторизация
  Future<String> auth(Map authData);

  // получить конфигурацию web
  Future<Map> getWebConfig();

  // сохранить кофигурацию на сервере
  Future<void> saveConfig(Map newConfig);

  // загрузить файл на сервер
  Future<String> uploadFile(FilePickerResult picked);

}