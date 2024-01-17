import 'package:flutter/material.dart';

import '../../colors.dart';

Widget showSettings(bool currentValue, Function update){
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Container(
      width: 500,
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
            Text('Показ данного контента, в настоящий момент, ${currentValue ? 'разрешен' : 'запрещен'}.', style: firm14,),
            Row(
              children: [
                Switch(
                  activeColor: firmColor,
                  inactiveThumbColor: firmColor.withOpacity(0.4),
                  value: currentValue, 
                  onChanged: (bool value) {
                    update('show', value);
                  }
                ),
                Expanded(
                  child: Text(currentValue ? 'запретить показ' : 'разрешить показ', style:  firm13,)
                )
              ],
            ),
          ],
        )
      ),
    ),
  );
}