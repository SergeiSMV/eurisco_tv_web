import 'package:eurisco_tv_web/presentation/mobile/drawer_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_utils/src/platform/platform.dart';

import '../../colors.dart';
import '../../data/providers.dart';
import 'appbar_mobile.dart';
import 'content_mobile.dart';
import 'empty_config.dart';

class MainMobile extends ConsumerStatefulWidget {
  const MainMobile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainMobileState();
}

class _MainMobileState extends ConsumerState<MainMobile> {

  bool isMobile = GetPlatform.isMobile;

  @override
  Widget build(BuildContext context) {

    // log.d(isMobile.toString());

    final webConfig = ref.watch(getWebConfigProvider);
    // ignore: unused_local_variable
    final messenger = ScaffoldMessenger.of(context);

    return ProgressHUD(
      barrierColor: Colors.white.withOpacity(0.7),
      padding: const EdgeInsets.all(20.0),
      child: Builder(
        builder: (context) {

          // ignore: unused_local_variable
          final progress = ProgressHUD.of(context);

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
                          child: const ContentMobile()
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