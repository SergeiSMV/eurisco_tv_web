import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../colors.dart';

Widget deleteContent(BuildContext context){
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
            Text('Удаление текущего контента. Контент будет безвозвратно удален!', style: firm14,),
            Row(
              children: [
                const Icon(Icons.delete, color: Colors.red, size: 20,),
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                  child: Text('УДАЛИТЬ', style: GoogleFonts.montserrat(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w700),),
                )
              ],
            ),
          ],
        )
      ),
    ),
  );
}