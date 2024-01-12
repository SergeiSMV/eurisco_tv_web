import 'dart:collection';

import 'package:eurisco_tv_web/domain/config_repository.dart';

class ConfigImpl extends ConfigRepository{
  
  // добавление глобальных настроек
  @override
  Map addGlobalSettings(Map config) {
    Map template = config[config.keys.toList().first]['content'];
    Map global = {
      "content": template,
      "name": "для всех устройств"
    };
    Map newConfig = LinkedHashMap.from({'общая настройка': global, ...config});
    return newConfig;
  }

}