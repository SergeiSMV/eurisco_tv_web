


import 'package:flutter/material.dart';

import '../../../../colors.dart';

Widget bannerTimeSettings(String hint){
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
            Text('Длительность показа баннера', style: firm14,),
            const SizedBox(height: 10,),
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
                keyboardType: TextInputType.number,
                style: firm15,
                minLines: 1,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: grey15,
                  hintText: hint,
                  prefixIcon: const IconTheme(data: IconThemeData(color: Color(0xFF687797)), child: Icon(Icons.timer)),
                  isCollapsed: true
                ),
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