
// https://fluthon.space/develop/auth

String ws = 'wss://fluthon.space/develop/ws';

// главный сервер
String server = 'https://fluthon.space/develop';

// запрос рассылки обновленной конфигурации
String serverBroadcast = '$server/broadcast';

// авторизация 
String serverAuth = '$server/auth';

// запрос конфигурации для Android
String serverGetAndroidConfig = '$server/get_config_android';

// сохранение файла на сервере
String serverUpload = '$server/upload';

// запрос конфигурации для Android
String serverGetWebConfig = '$server/get_config_web';

// переименовать устройство
String serverRenameDevice = '$server/rename_device';

// сохранить конфигурацию
String serverSaveConfig = '$server/save_config';

// удалить контент
String serverDeleteContent = '$server/delete_content';

// запросить pin код для добавления устройства
String serverGetPinCode = '$server/get_pincode';

// удалить pin код для добавления устройства
String serverDelPinCode = '$server/del_pincode';

// скачивание файлов
String getFile = '$server/get_media';

// скачивание файлов
String getBGFile = '$server/get_background';