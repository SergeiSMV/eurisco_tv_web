import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../colors.dart';
import '../data/providers.dart';
import '../data/server_implementation.dart';
import '../domain/server_values.dart';
import '../globals.dart';
import 'empty_config.dart';
import 'screen_manager.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewMainScreenState();
}

class _NewMainScreenState extends ConsumerState<MainScreen> {

  // late WebSocketChannel wsChannel;

  @override
  void initState() {
    super.initState();
    wsChannel = WebSocketChannel.connect(Uri.parse(ws));
    ServerImpl().websocketConnect(wsChannel!, ref);
  }

  @override
  void dispose() async {
    super.dispose();
    ServerImpl().websocketDisconnect(wsChannel!);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(getWebConfigProvider).when(
          loading: () => Center(child: CircularProgressIndicator(strokeWidth: 2.0, color: darkFirmColor,)),
          error: (error, _) => Center(child: Text(error.toString())),
          data: (_){
            final configs = ref.watch(configProvider);
            return configs.isEmpty ? emptyConfig(context) : ScreenManager(configs: configs);
          }
        );
      }
    );
  }
}