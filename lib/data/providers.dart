import 'package:eurisco_tv_web/data/config_implementation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../globals.dart';
import 'server_implementation.dart';


final configProvider = StateProvider<Map>((ref) {
  return {};
});

final deviceIdProvider = StateProvider((ref) {
  return '';
});

final deviceRenameProvider = StateProvider((ref) {
  return '';
});

final contentIndexProvider = StateProvider((ref) {
  return 0;
});

final getWebConfigProvider = FutureProvider((ref) async {
  Map config = await ServerImpl().getWebConfig();
  config.length > 1 ? 
    ref.read(configProvider.notifier).state = ConfigImpl().addGlobalSettings(config) :
    ref.read(configProvider.notifier).state = config;
  final finalConfig = ref.read(configProvider);
  config.isEmpty || config is List ? null : ref.read(deviceIdProvider.notifier).state = finalConfig.keys.toList().first;
});