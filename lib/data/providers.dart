import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'server_implementation.dart';


final configProvider = StateProvider<Map>((ref) {
  return {};
});

final deviceIdProvider = StateProvider((ref) {
  return '';
});

final contentIndexProvider = StateProvider((ref) {
  return 0;
});

final getWebConfigProvider = FutureProvider((ref) async {
  Map config = await ServerImpl().getWebConfig();
  ref.read(configProvider.notifier).state = config;
  config.isEmpty || config is List ? null : ref.read(deviceIdProvider.notifier).state = config.keys.toList().first;
});