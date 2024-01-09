import 'dart:collection';

import 'package:eurisco_tv_web/domain/config_repository.dart';

import '../globals.dart';

class ConfigImpl extends ConfigRepository{
  
  // добавление глобальных настроек
  @override
  Map addGlobalSettings(Map config) {
    List template = List.from(config[config.keys.toList().first]['content']);
    Map global = {
      "content": template,
      "name": "для всех устройств"
    };
    Map newConfig = LinkedHashMap.from({'общая настройка': global, ...config});
    log.d(newConfig);
    return newConfig;
  }

}