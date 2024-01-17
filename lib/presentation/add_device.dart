

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors.dart';

pinCode(BuildContext context, String pin){
  return showDialog(
    barrierDismissible: false,
    context: context, 
    builder: (context){
      return AlertDialog(
        title: Column(
          children: [
            Text('Ввведите данный пинкод на устройстве. Данное сообщение не закрывайте, пока устройство не будет подключено!', style: firm12, textAlign: TextAlign.center,),
            const SizedBox(height: 5),
            Text('При закрытии сообщения пинкод станет не действительным!', style: red12, textAlign: TextAlign.center,),
            const SizedBox(height: 15),
            Text(pin, style: GoogleFonts.montserrat(color: darkFirmColor, fontSize: 30, fontWeight: FontWeight.w700)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () { 
                    Navigator.pop(context);
                  }, 
                  child: Text('подключено', style: firm14,)
                ),
                TextButton(
                  onPressed: ()  { 
                    Navigator.pop(context);
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