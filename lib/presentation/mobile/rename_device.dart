import 'package:eurisco_tv_web/data/server_implementation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../colors.dart';
import '../../data/providers.dart';

renameDevice(BuildContext mainContext, String deviceID){

  final messenger = ScaffoldMessenger.of(mainContext);

  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: mainContext, 
    builder: (context){
      return ProviderScope(
        parent: ProviderScope.containerOf(mainContext),
        child: Consumer(
          builder: (context, ref, child) {

            final newDeviceName = ref.watch(deviceRenameProvider);

            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0)),
                color: Color(0xFFe3efff),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 35, top: 50),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.transparent
                        ),
                        color: Colors.white,
                      ),
                      height: 45,
                      width: 300,
                      child: TextField(
                        autofocus: true,
                        style: firm15,
                        minLines: 1,
                        obscureText: false,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: grey15,
                          hintText: 'новое имя устройства',
                          prefixIcon: const IconTheme(data: IconThemeData(color: Color(0xFF687797)), child: Icon(Icons.edit)),
                          isCollapsed: true
                        ),
                        onChanged: (value){ ref.read(deviceRenameProvider.notifier).state = value; },
                        onSubmitted: (_) {  },
                      ),
                    ),
                  ),

                  newDeviceName.isEmpty ? const SizedBox.shrink() : const SizedBox(height: 20,),

                  newDeviceName.isEmpty ? const SizedBox.shrink() :
                  Padding(
                    padding: const EdgeInsets.only(left: 35, right: 35),
                    child: InkWell(
                      onTap: () async { 
                        
                        await ServerImpl().renameDevice(newDeviceName, deviceID).then((value) {
                          messenger._toast(value);
                          ref.read(deviceRenameProvider.notifier).state = '';
                          Navigator.pop(context);
                        });
                        
                      },
                      child: Container(
                        decoration: BoxDecoration(color: const Color(0xFF96A0B7), borderRadius: BorderRadius.circular(5)),
                        height: 35,
                        width: 300,
                        child: Center(child: Text('сохранить', style: white14)),
                      ),
                    ),
                  ),
            
                  Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: const SizedBox(height: 30),
                  ),
                ],
              ),
            );
          }
        ),
      );
    }
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