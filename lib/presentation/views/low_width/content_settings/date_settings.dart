import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../colors.dart';

Widget dateSettings(BuildContext context, String startHint, String endHint, Function update){
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
            Text('Дата начала показа', style: firm14,),
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
                  String result = await _selectDate(context, startHint);
                  result.isEmpty ? null : {
                    update('start_date', result)
                  };
                },
                onChanged: (_){  },
                onSubmitted: (_) {  },
              ),
            ),

            const SizedBox(height: 10,),

            Text('Дата окончания показа', style: firm14,),
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
                  String result = await _selectDate(context, endHint);
                  result.isEmpty ? null : {
                    update('end_date', result)
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

Future<String> _selectDate(BuildContext context, String initDate) async {
  // DateTime? selectedDate;

  DateFormat format = DateFormat('dd.MM.yyyy');
  DateTime dateTime = format.parse(initDate);

  String date;
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: dateTime,
    firstDate: DateTime(2024),
    lastDate: DateTime(2034),
  );
  if (picked != null){
    date = DateFormat('dd.MM.yyyy').format(picked);
  } else {
    date = '';
  }

  return date;

}