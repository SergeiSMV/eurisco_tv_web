import 'package:flutter/material.dart';

import '../colors.dart';
import '../data/config_implementation.dart';
import 'drawer.dart';

Widget emptyContent(BuildContext mainContext){

  final messenger = ScaffoldMessenger.of(mainContext);

  return Scaffold(
    drawer: drawer(mainContext),
    body: Container(
      height: MediaQuery.of(mainContext).size.height,
      width: MediaQuery.of(mainContext).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          opacity: 0.1,
          image: AssetImage('lib/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Image.asset('lib/images/empty_box.png', scale: 3.0,),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text('отсутствует контент', style: darkFirm14, textAlign: TextAlign.center,),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: InkWell(
                onTap: () async {
                  String uploadMessage = await ConfigImpl().uploadFile();
                  messenger._toast(uploadMessage);
                },
                child: Container(
                  decoration: BoxDecoration(color: firmColor, borderRadius: BorderRadius.circular(5)),
                  height: 35,
                  width: 180,
                  child: Center(
                    child: Text('добавить файл', style: white14)
                  ),
                ),
              ),
            ),
          ],
        )),
    ),
  );
}

extension on ScaffoldMessengerState {
  void _toast(String message){
    showSnackBar(
      SnackBar(
        content: Text(message, style: white14,), 
        duration: const Duration(seconds: 5),
      )
    );
  }
}