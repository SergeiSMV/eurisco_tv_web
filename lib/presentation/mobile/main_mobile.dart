import 'package:eurisco_tv_web/presentation/auth.dart';
import 'package:eurisco_tv_web/presentation/mobile/drawer_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../colors.dart';
import '../../data/providers.dart';
import 'appbar_mobile.dart';

class MainMobile extends ConsumerStatefulWidget {
  const MainMobile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainMobileState();
}

class _MainMobileState extends ConsumerState<MainMobile> {

  @override
  Widget build(BuildContext context) {

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
                loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 1.0,)),
                error: (error, _) => Text(error.toString()),
                data: (data){

                  final allConfigs = ref.watch(configProvider);
                  

                  return allConfigs.isEmpty ?
                  
                  Scaffold(
                    appBar: AppBar(
                      iconTheme: IconThemeData(color: firmColor),
                      backgroundColor: const Color(0xFFe3efff),
                      elevation: 0,
                    ),
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
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Image.asset('lib/images/empty_box.png', scale: 3.0,),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text('доступных устройств\nне найдено', style: darkFirm14, textAlign: TextAlign.center,),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 35, right: 35),
                              child: InkWell(
                                onTap: () { },
                                child: Container(
                                  decoration: BoxDecoration(color: firmColor, borderRadius: BorderRadius.circular(5)),
                                  height: 35,
                                  width: 180,
                                  child: Center(
                                    child: Text('добавить', style: white14)
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                    ),
                  )

                  :
                  
                  Builder(
                    builder: (context) {

                      List devices = allConfigs.keys.toList();
                      final deviceIndex = ref.watch(contentIndexProvider);
            
                      Map deviceINFO = allConfigs[devices[deviceIndex]];
                      String deviceID = devices[deviceIndex];
                      String deviceName = deviceINFO['name'];

                      return Scaffold(
                        appBar: appbarMobile(context, deviceID, deviceName),
                        drawer: drawerMobile(context),
                        body: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              opacity: 0.5,
                              image: AssetImage('lib/images/background.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('Main Mobile'),
                                const SizedBox(height: 20,),
                                TextButton(onPressed: (){ 
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Auth()));
                                }, child: const Text('to Auth'))
                              ],
                            ),
                          ),
                        ),
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