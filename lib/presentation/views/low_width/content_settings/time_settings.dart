import 'package:flutter/material.dart';

import '../../../../colors.dart';
import '../../../../globals.dart';

Widget timeSettings(BuildContext context, String startHint, String endHint, Function update){
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ежедневное время начала показа', style: firm14,),
            const SizedBox(height: 5,),
            Container(
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
                readOnly: true,
                keyboardType: TextInputType.number,
                // controller: startController,
                style: firm15,
                minLines: 1,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: firm15,
                  hintText: startHint,
                  prefixIcon: const IconTheme(data: IconThemeData(color: Color(0xFF687797)), child: Icon(Icons.calendar_month)),
                  isCollapsed: true
                ),
                onTap: () async {
                  String result = await _selectTime(context);
                  result.isEmpty ? null : {
                    update('start_time', result)
                  };
                },
                onChanged: (_){  },
                onSubmitted: (_) {  },
              ),
            ),

            const SizedBox(height: 10,),

            Text('Ежедневное время окончания показа', style: firm14,),
            const SizedBox(height: 5,),
            Container(
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
                readOnly: true,
                keyboardType: TextInputType.number,
                // controller: endController,
                style: firm15,
                minLines: 1,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: firm15,
                  hintText: endHint,
                  prefixIcon: const IconTheme(data: IconThemeData(color: Color(0xFF687797)), child: Icon(Icons.calendar_month)),
                  isCollapsed: true
                ),
                onTap: () async {
                  String result = await _selectTime(context);
                  result.isEmpty ? null : {
                    update('end_time', result)
                  };
                },
                onChanged: (_){  },
                onSubmitted: (_) {  },
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Future<String> _selectTime(BuildContext context) async {

  String time;
  final TimeOfDay? picked = await showTimePicker(
    initialEntryMode: TimePickerEntryMode.inputOnly,
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
  );
  if (picked != null){
    time = '${picked.hour}:${picked.minute}';
    log.d(picked);
  } else { time = ''; }
  return time;
}



