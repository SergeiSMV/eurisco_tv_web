import 'package:hive_flutter/hive_flutter.dart';

import '../domain/hive_repository.dart';

class HiveImpl extends HiveRepository{

  final Box hive = Hive.box('hiveStorage');

  // сохранить логин / пароль
  @override
  Future<void> saveAuthData(Map authData) async {
    await hive.put('authData', authData);
  }

  // получить логин / пароль
  @override
  Future<Map> getAuthData() async {
    Map authData = await hive.get('authData', defaultValue: {});
    return authData;
  }


}