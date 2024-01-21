import 'package:flutter/material.dart';

import '../colors.dart';
import '../data/server_implementation.dart';
import 'add_device.dart';
import 'drawer.dart';

Widget emptyConfig(BuildContext context){
  return Scaffold(
    appBar: AppBar(
      iconTheme: IconThemeData(color: firmColor),
      backgroundColor: const Color(0xFFe3efff),
      elevation: 0,
    ),
    drawer: drawer(context),
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
              child: Text('доступных устройств\nне найдено', style: darkFirm14, textAlign: TextAlign.center,),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: InkWell(
                onTap: () async { 
                  ServerImpl().getPinCode().then((value) async {
                    await pinCode(context, value).then((_){
                      ServerImpl().delPinCode(value);
                    });
                  });
                },
                child: Container(
                  decoration: BoxDecoration(color: firmColor, borderRadius: BorderRadius.circular(5)),
                  height: 35,
                  width: 180,
                  child: Center(
                    child: Text('добавить', style: white14)
                  ),
                ),
              ),
            ),
          ],
        )),
    ),
  );
}