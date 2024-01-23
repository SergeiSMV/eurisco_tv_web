import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../colors.dart';

Widget deleteContent(BuildContext context, Function deleteContent){
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
            Text('Удаление текущего контента. Контент будет безвозвратно удален со всех устройств!', style: firm14,),
            Row(
              children: [
                const SizedBox(width: 10,),
                const Icon(Icons.delete, color: Colors.red, size: 20,),
                TextButton(
                  onPressed: () async {
                    await confirmDelete(context).then((value){
                      value == 'cancel' ? null : {
                        deleteContent(),
                        Navigator.pop(context)
                      };
                    });
                  }, 
                  child: Text('УДАЛИТЬ', style: GoogleFonts.montserrat(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600),),
                )
              ],
            ),
          ],
        )
      ),
    ),
  );
}


confirmDelete(BuildContext context){
  return showDialog(
    context: context, 
    builder: (context){
      return AlertDialog(
        title: Text('Вы действительно хотите удалить данный контент со всех устройств?', style: firm14,),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () { 
                    Navigator.pop(context, 'delete');
                  }, 
                  child: Text('удалить', style: firm14,)
                ),
                TextButton(
                  onPressed: ()  { 
                    Navigator.pop(context, 'cancel');
                  }, 
                  child: Text('отмена', style: firm14,)
                ),
              ],
            ),
          )
        ],
      );
    }
  );
}