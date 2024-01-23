import 'dart:convert';

import 'package:eurisco_tv_web/colors.dart';
import 'package:eurisco_tv_web/data/server_implementation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';
import 'appbar.dart';
import 'drawer.dart';
import 'contents.dart';

class ScreenManager extends ConsumerWidget {
  final Map configs;
  const ScreenManager({super.key, required this.configs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final editConfigs = ref.watch(editConfigProvider);

    bool save = jsonEncode(configs) == jsonEncode(editConfigs);

    final deviceIndex = ref.watch(deviceIndexProvider);
    List allDevices = configs.keys.toList();

    Map deviceINFO = configs[allDevices[deviceIndex]];
    String deviceID = allDevices[deviceIndex];
    String deviceName = deviceINFO['name'];

    final messenger = ScaffoldMessenger.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(context, deviceID, deviceName),
      drawer: drawer(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 1,
            image: AssetImage('lib/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        // child: Center(child: Text('welcome to NewScreenManager ($deviceID, $deviceName)'),),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: Contents(deviceID: deviceID)),
            !save ? const SizedBox(width: 10) : const SizedBox.shrink(),
            !save ?
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        ServerImpl().saveConfigSettings(editConfigs).then((value) {
                          messenger._toast(value);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.amber.shade900, borderRadius: BorderRadius.circular(5)),
                        height: 35,
                        width: 130,
                        child: Center(child: Text('сохранить', style: white14)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        ref.read(editConfigProvider.notifier).state = configs;
                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.amber.shade900, borderRadius: BorderRadius.circular(5)),
                        height: 35,
                        width: 130,
                        child: Center(child: Text('отменить', style: white14)),
                      ),
                    ),
                  ],
                ),
              ),
            ) : const SizedBox.shrink()
          ],
        )
      )
    );
  }
}

extension on ScaffoldMessengerState {
  void _toast(String message){
    showSnackBar(
      SnackBar(
        content: Text(message), 
        duration: const Duration(seconds: 4),
      )
    );
  }
}