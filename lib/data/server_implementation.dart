import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../domain/server_repository.dart';
import '../domain/server_values.dart';
import '../globals.dart';
import 'hive_implementation.dart';
import 'providers.dart';


class ServerImpl extends ServerRepository{

  final dio = Dio();

  // ручная авторизация
  @override
  Future<String> auth(Map authData) async {
    var data = jsonEncode(authData);
    String result;

    // final queryParameters = {'auth_data': data};
    // var url = Uri.https('fluthon.space', '/develop/auth', queryParameters);
    // try{
    //   var response = await http.get(url);
    //   result = response.statusCode.toString();
    //   log(result);
    // } on Exception catch (e){
    //   result = e.toString();
    // }

    // var response = await http.get(url);
    // if (response.statusCode == 200) {
    //   // result = jsonDecode(response.body.toString());
    //   result = response.statusCode.toString();
    //   log(result);
    // } else {
    //   result = response.statusCode.toString();
    //   print('Request failed with status: ${response.statusCode}.');
    // }

    
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

  // сохранить кофигурацию на сервере
  @override
  Future<void> saveConfig(Map newConfig) async {
    // получаем авторизационные данные из БД
    Map authData = await HiveImpl().getAuthData();
    var data = jsonEncode(newConfig);
    try{
      // запрос к серверу
      await dio.get(serverSaveConfig, queryParameters: {'user': authData['login'], 'config': data});
    } on DioException catch (_){
      null;
    }
  }


  // загрузить файл на сервер
  @override
  Future<String> uploadFile(FilePickerResult picked) async {
    String result;
    Map authData = await HiveImpl().getAuthData();
    Uint8List fileBytes = picked.files.first.bytes!;
    String fileName = picked.files.first.name;

    FormData formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
    });

    var responce = await dio.post(serverUpload, data: formData, queryParameters: {'user': authData['login']});
    responce.data is String ? result = responce.toString() : result = 'failed';

    return result;
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
      // ignore: unused_result
      result == 'update' ? ref.refresh(getWebConfigProvider) : null;
    });
  }

  // отключение от websocket
  @override
  Future<void> websocketDisconnect(WebSocketChannel channel) async {
    channel.sink.close();
  }
  
}