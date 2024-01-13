import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../colors.dart';
import '../../data/config_implementation.dart';
import '../../data/hive_implementation.dart';
import '../../data/providers.dart';
import '../auth.dart';



Widget drawerMobile(BuildContext mainContext){

  final progress = ProgressHUD.of(mainContext);
  final messenger = ScaffoldMessenger.of(mainContext);

  return ProviderScope(
    parent: ProviderScope.containerOf(mainContext),
    child: Consumer(
      builder: (context, ref, child) {

        final allConfigs = ref.watch(configProvider);

        return allConfigs.isEmpty ?
        Drawer(
          backgroundColor: const Color(0xFFf2f6ff),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      Opacity(opacity: 0.4, child: Image.asset('lib/images/eurisco_tv.png', scale: 4.5)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      Image.asset('lib/images/wrench.png', scale: 5.0,),
                      const Flexible(
                        child: Divider(color: Color(0xFF96a0b7), height: 30, endIndent: 30, indent: 10,),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, right: 30),
                  child: InkWell(
                    onTap: (){ Navigator.pop(mainContext); },
                    child: _drawerButton('добавить устройство', Icons.add),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, right: 30),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(mainContext).pushReplacement(MaterialPageRoute(builder: (context) => const Auth()));
                      HiveImpl().saveAuthData({});
                    },
                    child: _drawerButton('выйти', Icons.exit_to_app_outlined),
                  ),
                ),
              ],
            ),
          ),
        ) 
        :
        Builder(
          builder: (context) {
            List devices = allConfigs.keys.toList();
            return Drawer(
              backgroundColor: const Color(0xFFf2f6ff),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          const Expanded(child: SizedBox()),
                          Opacity(opacity: 0.4, child: Image.asset('lib/images/eurisco_tv.png', scale: 4.5)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        children: [
                          Image.asset('lib/images/tv_box.png', scale: 5.0,),
                          const Flexible(
                            child: Divider(color: Color(0xFF96a0b7), height: 30, endIndent: 30, indent: 10,),
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      child: GlowingOverscrollIndicator(
                        showLeading: false,
                        showTrailing: false,
                        axisDirection: AxisDirection.down,
                        color: Colors.transparent,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: devices.length,
                          itemBuilder: (context, index){
                            Map deviceINFO = allConfigs[devices[index]];
                            String deviceID = devices[index];
                            String deviceName = deviceINFO['name'];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10, right: 30),
                              child: InkWell(
                                onTap: (){
                                  ref.read(contentIndexProvider.notifier).state = index;
                                  Navigator.pop(context);
                                },
                                child: _drawerDevice(deviceID, deviceName),
                              ),
                            );
                          }
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        children: [
                          Image.asset('lib/images/wrench.png', scale: 5.0,),
                          const Flexible(
                            child: Divider(color: Color(0xFF96a0b7), height: 30, endIndent: 30, indent: 10,),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, right: 30),
                      child: InkWell(
                        onTap: () async {
                          progress?.show();
                          Navigator.pop(mainContext);
                          String uploadMessage = await ConfigImpl().uploadFile();
                          messenger._toast(uploadMessage);
                          progress?.dismiss();
                        },
                        child: _drawerButton('добавить файл', Icons.add),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, right: 30),
                      child: InkWell(
                        onTap: (){ Navigator.pop(mainContext); },
                        child: _drawerButton('добавить устройство', Icons.add),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, right: 30),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(mainContext).pushReplacement(MaterialPageRoute(builder: (context) => const Auth()));
                          HiveImpl().saveAuthData({});
                        },
                        child: _drawerButton('выйти', Icons.exit_to_app_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    ),
  );
}


Widget _drawerDevice(String device, String name){
  String deviceHint = device == 'общая настройка' ? '' : 'id: ';
  String nameHint = name == 'для всех устройств' ? '' : 'имя: ';
  return Container(
    decoration: BoxDecoration(
      // color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: <Color>[
          Colors.white,
          Colors.white.withOpacity(0.5),
          Colors.white.withOpacity(0.0)
        ],
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$deviceHint$device', style: firm14,),
          Text('$nameHint$name', style: firm12,),
        ],
      ),
    ),
  );
}

Widget _drawerButton(String hint, IconData icon){
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      // color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: <Color>[
          const Color(0xFF96a0b7),
          const Color(0xFF96a0b7).withOpacity(0.6),
          const Color(0xFF96a0b7).withOpacity(0.3),
          const Color(0xFF96a0b7).withOpacity(0.0)
        ],
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(hint, style: white14,),
    ),
  );
}

extension on ScaffoldMessengerState {
  void _toast(String message){
    showSnackBar(
      SnackBar(
        content: Text(message), 
        duration: const Duration(seconds: 5),
      )
    );
  }
}
