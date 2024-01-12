import 'package:file_picker/file_picker.dart';
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
  Future<String> uploadFile(FilePickerResult picked);

  // подключение к websocket
  Future<void> websocketConnect(WebSocketChannel channel, WidgetRef ref);

  // отключение от websocket
  Future<void> websocketDisconnect(WebSocketChannel channel);

}