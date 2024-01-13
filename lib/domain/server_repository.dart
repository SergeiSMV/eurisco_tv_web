import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class ServerRepository{

  // ручная авторизация
  Future<String> auth(Map authData);

  // получить конфигурацию web
  Future<Map> getWebConfig();

  // сохранить кофигурацию на сервере
  Future<void> saveConfig(Map newConfig);

  // загрузить файл на сервер
  Future<String> sendFileToServer(FormData formData);

  // подключение к websocket
  Future<void> websocketConnect(WebSocketChannel channel, WidgetRef ref);

  // отключение от websocket
  Future<void> websocketDisconnect(WebSocketChannel channel);

  // переименовать устройство
  Future<String> renameDevice(String newName, String deviceID);

  // запрос рассылки обновленной конфигурации
  Future<void> broadcast();

}