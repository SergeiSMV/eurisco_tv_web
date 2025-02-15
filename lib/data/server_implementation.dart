import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../domain/server_repository.dart';
import '../domain/server_values.dart';
import '../globals.dart';
import '../presentation/js_reload.dart';
import 'hive_implementation.dart';
import 'providers.dart';


class ServerImpl extends ServerRepository{

  final dio = Dio();

  // ручная авторизация
  @override
  Future<String> auth(Map authData) async {
    var data = jsonEncode(authData);
    String result;
    
    try{
      var responce = await dio.get(serverAuth, queryParameters: {'auth_data': data});
      result = responce.toString();
    } 
    on DioException catch (e){
      // result = 'no connection';
      result = e.toString();
    }
    result == 'admitted' ? HiveImpl().saveAuthData(authData) : null;
    
    return result;
  }

  // получить конфигурацию web
  @override
  Future<Map> getWebConfig() async {
    // получаем авторизационные данные из локальной БД
    Map authData = await HiveImpl().getAuthData();
    try{
      // запрос к серверу
      var responce = await dio.get(serverGetWebConfig, queryParameters: {'user': authData['login']});
      // декодируем ответ от сервера
      var decodeResponse = jsonDecode(responce.toString());
      final Map config = decodeResponse is Map ? decodeResponse : {};
      return config;
    } on DioException catch (_){
      return {};
    }
  }

  // загрузить файл на сервер
  @override
  Future<String> sendFileToServer(FormData formData) async {
    Map authData = await HiveImpl().getAuthData();
    var result = await dio.post(serverUpload, data: formData, queryParameters: {'user': authData['login']});
    return result.data is String ? result.data : '';
  }

  // подключение к websocket
  @override
  Future<void> websocketConnect(WebSocketChannel channel, WidgetRef ref) async {
    Map authData = await HiveImpl().getAuthData();
    String client = authData['login'];
    dynamic result;

    channel.sink.add(client);
    channel.stream.listen((value) {
      result = jsonDecode(value);
      result == 'update' ? { ref.refresh(getWebConfigProvider) } : null;
    });
  }

  // отключение от websocket
  @override
  Future<void> websocketDisconnect(WebSocketChannel channel) async {
    try{
      channel.sink.close();
    } catch (_){
      null;
    }
  }

  // проверить соединение websocket
  @override
  void checkWebsocketConnect() {
    if (wsChannel?.closeCode != null) {
      // Соединение закрыто или не открывалось
      refreshPage();
    } else {
        // Соединение возможно открыто
        null;
    }
  }

  // переименовать устройство
  @override
  Future<String> renameDevice(String newName, String deviceID) async {
    Map authData = await HiveImpl().getAuthData();
    String user = authData['login'];
    var result = await dio.post(serverRenameDevice, queryParameters: {'user': user, 'name': newName, 'device_id': deviceID,});
    checkWebsocketConnect();
    return result.data == 'done' ? 'Имя успешно изменено' : 'Ошибка сохранения';
  }

  // сохранить настройки кофигурации на сервере
  @override
  Future<String> saveConfigSettings(Map newConfig) async {
    String result;
    Map authData = await HiveImpl().getAuthData();
    String user = authData['login'];
    newConfig.remove('preview'); newConfig.remove('stream');
    try{
      // запрос к серверу
      var responce = await dio.post(serverSaveConfig, queryParameters: {'user': user, 'config': jsonEncode(newConfig)});
      result = responce.data == 'done' ? 'Конфигурация успешно сохранена' : 'Ошибка при попытке сохранить конфигурацию';
    } on DioException catch (_){
      result = 'Ошибка при попытке сохранить конфигурацию. Нет соединения с сервером.';
    }
    checkWebsocketConnect();
    return result;
  }

  // удалить контент
  @override
  Future<void> deleteContent(String content) async {
    Map authData = await HiveImpl().getAuthData();
    String user = authData['login'];
    try{
      dio.post(serverDeleteContent, queryParameters: {'user': user, 'content': content});
    } on DioException catch (_){
      null;
    }
    checkWebsocketConnect();
  }

  // удалить устройство
  @override
  Future<String> deleteDevice(String deviceID) async {
    String result;
    Map authData = await HiveImpl().getAuthData();
    String user = authData['login'];
    try{
      var responce = await dio.get(serverDeleteDevice, queryParameters: {'user': user, 'device_id': deviceID});
      result = responce.data == 'done' ? 'Устройство $deviceID успешно удалено' : 'Ошибка при попытке удалить устройство $deviceID';
    } on DioException catch (_){
      result = 'Ошибка при попытке удалить устройство $deviceID';
    }
    checkWebsocketConnect();
    return result;
  }

  // запросить pin код для добавления устройства
  @override
  Future<String> getPinCode() async {
    String result;
    Map authData = await HiveImpl().getAuthData();
    String user = authData['login'];
    try{
      var respoce = await dio.get(serverGetPinCode, queryParameters: {'user': user});
      result = respoce.data.toString();
    } on DioException catch (_){
      result = 'error';
    }
    return result;
  }

  // удалить запрошенный pin код
  @override
  Future<void> delPinCode(String pin) async {
    Map authData = await HiveImpl().getAuthData();
    String user = authData['login'];
    try{
      await dio.get(serverDelPinCode, queryParameters: {'user': user, 'pin': pin});
    } on DioException catch (_){
      null;
    }
  }
  
}