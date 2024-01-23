import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'server_implementation.dart';


final configProvider = StateProvider<Map>((ref) {
  return {};
});

final editConfigProvider = StateProvider<Map>((ref) {
  return {};
});

final deviceIdProvider = StateProvider((ref) {
  return '';
});

final deviceRenameProvider = StateProvider((ref) {
  return '';
});

final deviceIndexProvider = StateProvider((ref) {
  return 0;
});

final getWebConfigProvider = FutureProvider((ref) async {
  Map config = await ServerImpl().getWebConfig();
  ref.read(configProvider.notifier).state = config;
  ref.read(editConfigProvider.notifier).state = config;
});