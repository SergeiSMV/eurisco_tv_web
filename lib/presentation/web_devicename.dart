import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../colors.dart';
import '../data/providers.dart';
import '../data/server_implementation.dart';

class WebDeviceName extends ConsumerStatefulWidget {
  const WebDeviceName({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebDeviceNameState();
}

class _WebDeviceNameState extends ConsumerState<WebDeviceName> {

  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child){
        final allConfigs = ref.watch(configProvider);
        final deviceId = ref.watch(deviceIdProvider);
        String deviceName = allConfigs.isEmpty ? '' : allConfigs[deviceId]['name'];

        return allConfigs.isEmpty ? 
          const Text('') 
          :
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(deviceName, style: TextStyle(color: firmColor, fontSize: 14, fontWeight: FontWeight.w700),),
                const SizedBox(width: 10,),
                InkWell(
                  onTap: (){ _editName(context, deviceName, allConfigs, deviceId); },
                  child: Icon(
                    Icons.edit,
                    size: 20,
                    color: firmColor,
                  ),
                ),
              ],
            ),
          );
      },
    );
  }

  _editName(BuildContext context, String deviceName, Map allConfigs, String deviceId){
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context){
        return Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              AlertDialog(
                content: _enterValue(deviceName, nameController, (String value){
                  Map newConfig = allConfigs;
                  newConfig[deviceId]['name'] = value;
                  ref.read(configProvider.notifier).state = Map.from(newConfig);
                }),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10, right: 20),
                    child: TextButton(onPressed: () { 
                      nameController.clear(); 
                      // nameController.dispose();
                      ServerImpl().saveConfig(allConfigs);
                      Navigator.pop(context); 
                    }, child: const Text('сохранить')),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  _enterValue(String hint, TextEditingController controller, Function validate){
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SizedBox(
        height: 35,
        width: 300,
        // decoration: BoxDecoration(color: Colors.blue.shade200, borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: TextField(
                controller: controller,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.number,
                readOnly: false,
                style: firm16,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(bottom: 13),
                  hintText: hint,
                  hintStyle: grey16,
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                ),
                onChanged: (value){ validate(value); },
              ),
            ),
          ),
        ),
      ),
    );
  }

}

