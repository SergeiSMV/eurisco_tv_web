import 'dart:convert';

import 'package:eurisco_tv_web/data/server_implementation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import '../../../../colors.dart';
import '../../../../domain/config_model/config_model.dart';
import '../../../../globals.dart';
import 'delete_content.dart';
import 'settings_appbar.dart';
import 'show_settings.dart';
import 'date_settings.dart';
import 'banner_time_settings.dart';
import 'time_settings.dart';

class LowWidthContentSettings extends ConsumerStatefulWidget {
  final Map<String, dynamic> contentConfig;
  final String contentName;
  final String deviceID;
  final String deviceName;
  const LowWidthContentSettings({
    super.key, 
    required this.contentConfig, 
    required this.deviceID, 
    required this.contentName,
    required this.deviceName
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LowWidthContentSettingsState();
}

class _LowWidthContentSettingsState extends ConsumerState<LowWidthContentSettings> {

  TextEditingController durationController = TextEditingController();
  late Map<String, dynamic> editConfig;
  late bool mapsEquals;


  @override
  void initState() {
    super.initState();
    editConfig = Map.from(widget.contentConfig);
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
      editConfig[param] = value;
      mapsEquals = const DeepCollectionEquality().equals(editConfig, widget.contentConfig);
    });
    
  }

  @override
  Widget build(BuildContext context) {
    ConfigModel config = ConfigModel(configModel: editConfig);
    final messenger = ScaffoldMessenger.of(context);
    String extention = widget.contentName.split('.')[1];

    return ProgressHUD(

      child: Scaffold(
        backgroundColor: Colors.white,
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
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
    
              settingsAppBar(widget.deviceID, widget.deviceName, widget.contentName, config.preview),
        
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: <Widget>[
                      showSettings(config.show, updateConfig),
                      extention == 'mp4' || !config.show ? const SizedBox.shrink() : bannerTimeSettings(durationController, config.duration.toString(), updateConfig),
                      !config.show ? const SizedBox.shrink() : dateSettings(context, config.startDate, config.endDate, updateConfig),
                      !config.show ? const SizedBox.shrink() : timeSettings(context, config.startTime, config.endTime, updateConfig),
                      deleteContent(context, widget.contentName),
                      mapsEquals ? const SizedBox.shrink() : 
                      InkWell(
                        onTap: () async {

                          String validateResult = dataValidate();

                          validateResult == 'ok' ?
                          await ServerImpl().saveConfigSettings(editConfig, widget.deviceID, widget.contentName).then((value){
                            messenger._toast(value);
                            Navigator.pop(context);
                          }) : messenger._toast(validateResult);
                          
                        },
                        child: Container(
                          decoration: BoxDecoration(color: const Color(0xFF96A0B7), borderRadius: BorderRadius.circular(5)),
                          height: 35,
                          width: double.infinity,
                          child: Center(child: Text('сохранить', style: white14)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String dataValidate(){
    String validateResult = 'ok';
    DateFormat format = DateFormat("dd.MM.yyyy");
    int duration = editConfig['duration'] ?? 99999;
    bool show = editConfig['show'];

    String startDateString = editConfig['start_date'];
    DateTime startDate = format.parse(startDateString);

    String endDateString = editConfig['end_date'];
    DateTime endDate = format.parse(endDateString);

    String startTimeString = editConfig['start_time'];
    TimeOfDay startTime = stringToTimeOfDay(startTimeString);
    String endTimeString = editConfig['end_time'];
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