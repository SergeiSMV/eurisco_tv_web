import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import '../../colors.dart';
import '../../data/providers.dart';
import '../../domain/config_model/config_model.dart';
import '../../globals.dart';
import 'banner_time_settings.dart';
import 'date_settings.dart';
import 'delete_content.dart';
import 'settings_appbar.dart';
import 'show_settings.dart';
import 'time_settings.dart';

class ContentSettings extends ConsumerStatefulWidget {
  final Map editConfigs;
  final String contentName;
  final String deviceID;
  const ContentSettings({super.key, required this.editConfigs, required this.contentName, required this.deviceID});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LowWidthContentSettingsState();
}

class _LowWidthContentSettingsState extends ConsumerState<ContentSettings> {

  TextEditingController durationController = TextEditingController();
  late Map copyEditConfigs;
  late bool mapsEquals;
  bool changeAllDevice = false;


  @override
  void initState() {
    super.initState();
    // Сериализация и десериализация объектов в widget.editConfigs
    // создание полной независимой копии
    String json = jsonEncode(widget.editConfigs);
    copyEditConfigs = jsonDecode(json);
    mapsEquals = true;
  }

  @override
  void dispose() async {
    super.dispose();
    durationController.clear();
    durationController.dispose();
  }

  void updateConfig(String param, var value) {
    setState(() {
      copyEditConfigs[widget.deviceID]['content'][widget.contentName][param] = value;
      mapsEquals = const DeepCollectionEquality().equals(
        copyEditConfigs[widget.deviceID]['content'][widget.contentName], 
        widget.editConfigs[widget.deviceID]['content'][widget.contentName]
      );
    });
    
  }

  void removeContent() {
    for(var entry in copyEditConfigs.entries){
      copyEditConfigs[entry.key]['content'].remove(widget.contentName);
    }
    ref.read(editConfigProvider.notifier).state = copyEditConfigs;
  }

  void updateForAll() {
    for(var entry in copyEditConfigs.entries){
      if (entry.key != widget.deviceID){
        copyEditConfigs[entry.key]['content'][widget.contentName] = copyEditConfigs[widget.deviceID]['content'][widget.contentName];
        continue;
      }
    }
    ref.read(editConfigProvider.notifier).state = copyEditConfigs;
  }

  @override
  Widget build(BuildContext context) {
    
    final deviceIndex = ref.watch(deviceIndexProvider);
    List allDevices = copyEditConfigs.keys.toList();
    String deviceID = allDevices[deviceIndex];
    Map deviceINFO = copyEditConfigs[deviceID];
    String deviceName = deviceINFO['name'];
    Map<String, dynamic> targetContent = deviceINFO['content'][widget.contentName];

    // ignore: unused_local_variable
    final messenger = ScaffoldMessenger.of(context);
    String extention = widget.contentName.split('.')[1];

    ConfigModel config = ConfigModel(configModel: targetContent);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            
            screenWidth > screenWidthParam ? 
            SliverAppBar(
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1.0,
                background: Container(),
              ),
            ) :
            settingsAppBar(deviceID, deviceName, widget.contentName, config.preview),
      
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[

                    screenWidth < screenWidthParam ? const SizedBox.shrink() :
                    Container(
                      height: 200,
                      width: 500,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)
                        ),
                        image: DecorationImage(
                          image: NetworkImage(config.preview), // Ссылка на сетевое изображение
                          fit: BoxFit.cover, // Изображение покроет весь контейнер
                        ),
                        color: Colors.white,
                      ),
                      // child: Image.network(config.preview)
                    ),

                    screenWidth < screenWidthParam ? const SizedBox.shrink() :
                    Container(
                      padding: const EdgeInsets.all(5),
                      height: 80,
                      width: 500,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                        ),
                        color: Color(0xFF96A0B7),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.contentName, style: white13, overflow: TextOverflow.ellipsis),
                          Text(deviceID, style: white13, overflow: TextOverflow.ellipsis),
                          Text(deviceName, style: white13, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    screenWidth < screenWidthParam ? const SizedBox.shrink() : const SizedBox(height: 10),
                    showSettings(config.show, updateConfig),
                    extention == 'mp4' || !config.show ? const SizedBox.shrink() : bannerTimeSettings(durationController, config.duration.toString(), updateConfig),
                    !config.show ? const SizedBox.shrink() : dateSettings(context, config.startDate, config.endDate, updateConfig),
                    !config.show ? const SizedBox.shrink() : timeSettings(context, config.startTime, config.endTime, updateConfig),
                    deleteContent(context, removeContent),

                    mapsEquals ? const SizedBox.shrink() : 
                    
                    
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        width: 500,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Checkbox(
                              activeColor: const Color(0xFF96A0B7),
                              value: changeAllDevice,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  changeAllDevice = newValue!;
                                });
                              },
                            ),
                            const SizedBox(width: 10,),
                            Text('применить для всех устройств', style: darkFirm14,)
                          ],
                        ),
                      ),
                    ),

                    mapsEquals ? const SizedBox.shrink() : 
                    InkWell(
                      onTap: () async {
                        String validateResult = dataValidate(targetContent);
                        validateResult == 'ok' ?
                        {
                          changeAllDevice ? updateForAll() : ref.read(editConfigProvider.notifier).state = copyEditConfigs,
                          Navigator.pop(context)
                        } : messenger._toast(validateResult);
                        // await ServerImpl().saveConfigSettings(editConfig, widget.deviceID, widget.contentName).then((value){
                        //   messenger._toast(value);
                        //   Navigator.pop(context);
                        // }) 
                      },
                      child: Container(
                        decoration: BoxDecoration(color: const Color(0xFF96A0B7), borderRadius: BorderRadius.circular(5)),
                        height: 35,
                        width: 500,
                        child: Center(child: Text('сохранить', style: white14)),
                      ),
                    ),
                    const SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String dataValidate(Map targetContent){
    String validateResult = 'ok';
    DateFormat format = DateFormat("dd.MM.yyyy");
    int duration = targetContent['duration'] ?? 99999;
    bool show = targetContent['show'];

    String startDateString = targetContent['start_date'];
    DateTime startDate = format.parse(startDateString);

    String endDateString = targetContent['end_date'];
    DateTime endDate = format.parse(endDateString);

    String startTimeString = targetContent['start_time'];
    TimeOfDay startTime = stringToTimeOfDay(startTimeString);
    String endTimeString = targetContent['end_time'];
    TimeOfDay endTime = stringToTimeOfDay(endTimeString);
    int compire = compareTimeOfDay(startTime, endTime);

    
    if(!show){
      null;
    } else {
      duration <= 0 && duration != 99999 ? validateResult = 'длительность показа не может быть меньше или равной нулю' : null;
      endDate.isBefore(startDate) ? validateResult = 'дата начала показа не может быть позже даты окончания показа' : null;
      compire > 0 ? validateResult = 'время начала показа не может быть позже времени окончания показа' : null;
      compire == 0 ? validateResult = 'время начала показа не может быть равно времени окончания показа' : null;
    }
    
    return validateResult;
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

TimeOfDay stringToTimeOfDay(String timeString) {
  final hoursMinutes = timeString.split(":");
  final hours = int.parse(hoursMinutes[0]);
  final minutes = int.parse(hoursMinutes[1]);
  return TimeOfDay(hour: hours, minute: minutes);
}

int compareTimeOfDay(TimeOfDay t1, TimeOfDay t2) {
  // < 0, если первое время (t1) раньше второго (t2), 
  // > 0, если первое время (t1) позже второго (t2)
  // 0, если времена равны.
  if (t1.hour == t2.hour) {
    // Если часы равны, сравниваем минуты
    return t1.minute.compareTo(t2.minute);
  }
  return t1.hour.compareTo(t2.hour);
}