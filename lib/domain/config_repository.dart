abstract class ConfigRepository{

  // добавление глобальных настроек
  Map addGlobalSettings(Map config);

  // загрузка файла на сервер
  Future<String> uploadFile();

}