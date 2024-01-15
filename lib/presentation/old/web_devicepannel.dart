import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../colors.dart';
import '../../data/providers.dart';

class WebDevicePannel extends ConsumerWidget {
  const WebDevicePannel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 160, minWidth: MediaQuery.of(context).size.width),
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.shade400,
                spreadRadius: 0.5,
                blurRadius: 2,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Colors.blue.shade100,
                Colors.blue.shade50,
                Colors.white
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 0, left: 15),
            child: Consumer(
              builder: (context, ref, child) {
                
                final allConfigs = ref.watch(configProvider);
                List devices = allConfigs.keys.toList();
                final deviceIndex = ref.watch(contentIndexProvider);
                
                return allConfigs.isEmpty ? const SizedBox.shrink() :
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: devices.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
          
                      Map deviceINFO = allConfigs[devices[index]];
                      String deviceID = devices[index];
                      String deviceName = deviceINFO['name'];
          
                      return Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: InkWell(
                          onTap: (){ 
                            ref.read(contentIndexProvider.notifier).state = index;
                            ref.read(deviceIdProvider.notifier).state = deviceID;
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(child: Image.asset('lib/images/tv_box.png', scale: 4.0,)),
                                    const SizedBox(height: 10,),
                                    Text('ID: $deviceID', style: firm13,),
                                    Text('имя: $deviceName', style: firm13,),
                                    const SizedBox(height: 10,),
                                    index != deviceIndex ? const SizedBox(height: 5,) :
                                    Container(
                                      width: 100,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: index == deviceIndex ? Colors.lightGreenAccent.shade700 : Colors.transparent,
                                        borderRadius: BorderRadius.circular(3),
                                        boxShadow: [
                                          BoxShadow(
                                            color: index == deviceIndex ? Colors.lightGreen.shade900 : Colors.transparent,
                                            spreadRadius: 0.5,
                                            blurRadius: 1,
                                            offset: const Offset(0, 1), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
          
                    }
                  );
          
              }
            ),
          ),
        ),
      ),
    );
  }
}