
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../colors.dart';
import '../../data/providers.dart';
import '../../data/server_implementation.dart';

editDialog(BuildContext mainContext, int index, TextEditingController durController, TextEditingController startController, TextEditingController endController){
  return showDialog(
    barrierDismissible: false,
    context: mainContext, 
    builder: (context){

      return ProviderScope(
        parent: ProviderScope.containerOf(mainContext),
        child: Consumer(
          builder: (context, ref, child) {

            final allConfigs = ref.watch(configProvider);
            final deviceId = ref.watch(deviceIdProvider);
            List deviceConfig = allConfigs.isEmpty ? [] : allConfigs[deviceId]['content'];

            String extention = deviceConfig[index]['name'].split('.')[1];
            String duration = deviceConfig[index]['duration'].toString();
            String start = deviceConfig[index]['start'];
            String end = deviceConfig[index]['end'];
            String fileName = deviceConfig[index]['name'].split('.')[0].toString();
            bool show = deviceConfig[index]['show'];

            bool roundTheClock = start == '00:00' && end == '23:59' ? true : false;

            return Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  AlertDialog(
                    title: Row(
                      children: [
                        Icon(
                          Icons.settings,
                          size: 25,
                          color: firmColor,
                        ),
                        const SizedBox(width: 5,),
                        Text(fileName, style: firm16,),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                            SizedBox(width: 200, child: Text('разрешить показ:', style: firm14,)),
                            const SizedBox(width: 45,),
                            Switch(
                              activeColor: firmColor,
                              inactiveThumbColor: firmColor.withOpacity(0.4),
                              value: show, 
                              onChanged: (bool value) {
                                Map newConfig = allConfigs;
                                newConfig[deviceId]['content'][index]['show'] = value;
                                ref.read(configProvider.notifier).state = Map.from(newConfig);
                              }
                            ),
                          ],
                        ),

                        extention == 'mp4' ? const SizedBox.shrink() :
                          show ?
                            Row(
                              children: [
                                SizedBox(width: 200, child: Text('длительность (сек.):', style: firm14,)),
                                _enterValue(duration, durController, false, (String value){
                                  Map newConfig = allConfigs;
                                  String validResult = _durationValidate(value, durController);
                                  value.isEmpty ? newConfig[deviceId]['content'][index]['duration'] = 10 : 
                                    newConfig[deviceId]['content'][index]['duration'] = int.parse(validResult);
                                  ref.read(configProvider.notifier).state = Map.from(newConfig);
                                })
                              ],
                            ) : const SizedBox.shrink(),

                        show ?
                        Row(
                          children: [
                            SizedBox(width: 200, child: Text('круглосуточный показ:', style: firm14,)),
                            const SizedBox(width: 45,),
                            Switch(
                              activeColor: firmColor,
                              inactiveThumbColor: firmColor.withOpacity(0.4),
                              value: roundTheClock, 
                              onChanged: (bool value) {
                                Map newConfig = allConfigs;
                                value ? {
                                  newConfig[deviceId]['content'][index]['start'] = '00:00',
                                  newConfig[deviceId]['content'][index]['end'] = '23:59',
                                  startController.clear(), endController.clear()
                                } :
                                {
                                  newConfig[deviceId]['content'][index]['start'] = '10:00',
                                  newConfig[deviceId]['content'][index]['end'] = '18:00',
                                };
                                ref.read(configProvider.notifier).state = Map.from(newConfig);
                              }
                            ),
                          ],
                        ) : const SizedBox.shrink(),

                        show && !roundTheClock ?
                          Row(
                            children: [
                              SizedBox(width: 200, child: Text('начало:', style: firm14,)),
                              _enterValue(start, startController, roundTheClock, (String value){
                                Map newConfig = allConfigs;
                                final sanitizedText = value.replaceAll(':', '');
                                _addSeparator(sanitizedText, startController);
                                _timeValidate(value, startController);
                                startController.text.length == 5 ? {
                                  newConfig[deviceId]['content'][index]['start'] = value,
                                  ref.read(configProvider.notifier).state = Map.from(newConfig),
                                  startController.clear()
                                } : null;
                              })
                            ],
                          ) : const SizedBox.shrink(),

                        show && !roundTheClock ?
                          Row(
                            children: [
                              SizedBox(width: 200, child: Text('конец:', style: firm14,)),
                              _enterValue(end, endController, roundTheClock, (String value){
                                Map newConfig = allConfigs;
                                final sanitizedText = value.replaceAll(':', '');
                                _addSeparator(sanitizedText, endController);
                                _timeValidate(value, endController);
                                endController.text.length == 5 ? {
                                  newConfig[deviceId]['content'][index]['end'] = value,
                                  ref.read(configProvider.notifier).state = Map.from(newConfig),
                                  endController.clear()
                                } : null;
                              })
                            ],
                          ) : const SizedBox.shrink(),

                      ],
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 10, right: 20),
                        child: TextButton(onPressed: () { 
                          durController.clear(); startController.clear(); endController.clear();
                          ServerImpl().saveConfig(allConfigs);
                          Navigator.pop(context); 
                        }, child: const Text('сохранить')),
                      )
                    ],
                  ),
                ],
              ),
            );
          }
        )
      );
    }
  );
}

_addSeparator(String text, TextEditingController controller) {
  const int addDashEvery = 2;
  String out = '';
  for (int i = 0; i < text.length; i++) {
    if (i + 1 > addDashEvery && i % addDashEvery == 0) {
      out += ':';
    }
    out += text[i];
  }
  controller.text = out;
  controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
}

_timeValidate(String text, TextEditingController controller){
  String eTime = '';
  String fTime = '';
  List hours = List<String>.generate(24, (hour) { return hour < 10 ? '0$hour' : '$hour'; });
  List minutes = List<String>.generate(60, (minute) { return minute < 10 ? '0$minute' : '$minute'; });

  if(text.length == 2){
    hours.contains(text) ? null : controller.clear();
  } else { null; }

  if(text.length == 5){
    String textValidate = '${text.split('')[3]}${text.split('')[4]}';
    minutes.contains(textValidate) ? null : {
      fTime = text.replaceRange(3, 4, ''),
      eTime = fTime.replaceRange(3, 4, ''),
      controller.text = eTime,
      controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length))
    };
  } else { null; }

  if(text.length == 6){
    controller.text = text.replaceRange(5, 6, '');
    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
  } else { null; }
}

String _durationValidate(String text, TextEditingController controller){
  String dur;
  try{
    text == '0' || text.isEmpty ? int.parse('f') : int.parse(text);
    dur = text;
  } on Exception {
    controller.text = '';
    dur = '10';
  }
  return dur;
}

_enterValue(String hint, TextEditingController controller, bool readOnly, Function validate){
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SizedBox(
        height: 35,
        width: 80,
        // decoration: BoxDecoration(color: Colors.blue.shade200, borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: TextField(
            controller: controller,
            textAlign: TextAlign.right,
            keyboardType: TextInputType.number,
            readOnly: readOnly,
            style: firm16,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(bottom: 13),
              hintText: hint,
              hintStyle: grey16,
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
              // suffixIcon: _defineSuffixIcon(leading, hint),
            ),
            onChanged: (value){ validate(value); },
          ),
        ),
      ),
    );
  }