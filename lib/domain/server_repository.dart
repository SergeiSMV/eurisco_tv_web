import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class ServerRepository{

  // ручная авторизация
  Future<String> auth(Map authData);

  // получить конфигурацию web
  Future<Map> getWebConfig();

  // сохранить кофигурацию на сервере
  // Future<void> saveConfig(Map newConfig);

  // загрузить файл на сервер
  Future<String> sendFileToServer(FormData formData);

  // подключение к websocket
  Future<void> websocketConnect(WebSocketChannel channel, WidgetRef ref);

  // отключение от websocket
  Future<void> websocketDisconnect(WebSocketChannel channel);

  // проверить соединение websocket
  void checkWebsocketConnect();

  // переименовать устройство
  Future<String> renameDevice(String newName, String deviceID);

  // сохранить настройки кофигурации на сервере
  Future<String> saveConfigSettings(Map newConfig);

  // удалить контент
  Future<void> deleteContent(String content);

  // удалить устройство
  Future<String> deleteDevice(String deviceID);

  // запросить pin код для добавления устройства
  Future<String> getPinCode();

  // удалить запрошенный pin код
  Future<void> delPinCode(String pin);

}