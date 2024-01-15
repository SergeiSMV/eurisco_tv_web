import 'package:eurisco_tv_web/data/server_implementation.dart';
import 'package:eurisco_tv_web/presentation/mobile/drawer_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../colors.dart';
import '../../data/providers.dart';
import '../../domain/server_values.dart';
import '../../globals.dart';
import 'appbar_mobile.dart';
import '../views/low_width/lw_content_view.dart';
import 'empty_config.dart';
import '../views/high_width/hw_content_view.dart';

class MainMobile extends ConsumerStatefulWidget {
  const MainMobile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainMobileState();
}

class _MainMobileState extends ConsumerState<MainMobile> {
  
  bool isMobile = GetPlatform.isMobile;
  late WebSocketChannel wsCnannel;

  @override
  void initState() {
    super.initState();
    wsCnannel = WebSocketChannel.connect(Uri.parse(ws));
    ServerImpl().websocketConnect(wsCnannel, ref);
  }

  @override
  void dispose() async {
    super.dispose();
    log.d('dispose from MainMobile');
    ServerImpl().websocketDisconnect(wsCnannel);
  }

  

  @override
  Widget build(BuildContext context) {

    final webConfig = ref.watch(getWebConfigProvider);
    // ignore: unused_local_variable
    final messenger = ScaffoldMessenger.of(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return ProgressHUD(
      barrierColor: Colors.white.withOpacity(0.7),
      borderColor: Colors.transparent,
      // backgroundColor: Colors.transparent,
      padding: const EdgeInsets.all(20.0),
      child: Builder(
        builder: (progressHUDcontext) {

          
          // ignore: unused_local_variable
          final progress = ProgressHUD.of(progressHUDcontext);

          return Consumer(
            builder: (context, ref, child) {
              return webConfig.when(
                loading: () => Center(child: CircularProgressIndicator(strokeWidth: 2.0, color: darkFirmColor,)),
                error: (error, _) => Center(child: Text(error.toString())),
                data: (data){

                  final allConfigs = ref.watch(configProvider);
                  
                  return allConfigs.isEmpty ? emptyConfig(context) :
                  Builder(
                    builder: (context) {

                      List devices = allConfigs.keys.toList();
                      final deviceIndex = ref.watch(contentIndexProvider);
            
                      Map deviceINFO = allConfigs[devices[deviceIndex]];
                      String deviceID = devices[deviceIndex];
                      String deviceName = deviceINFO['name'];

                      return Scaffold(
                        backgroundColor: Colors.white,
                        appBar: appbarMobile(context, deviceID, deviceName),
                        drawer: drawerMobile(context),
                        body: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              opacity: 0.1,
                              image: AssetImage('lib/images/background.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: screenWidth > screenWidthParam ? const HighWidthContentView() : const LowWidthContentView()
                        )
                      );
                    }
                  );
                },  
              );
            }
          );
        }
      ),
    );
  }

}

extension on ScaffoldMessengerState {
  // ignore: unused_element
  void _toast(String message){
    showSnackBar(
      SnackBar(
        content: Text(message), 
        duration: const Duration(seconds: 4),
      )
    );
  }
}