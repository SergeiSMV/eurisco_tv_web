import 'package:flutter/material.dart';

import '../colors.dart';
import 'drawer.dart';

Widget emptyContent(BuildContext context){
  return Scaffold(
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
              child: Text('отсутствует контент', style: darkFirm14, textAlign: TextAlign.center,),
            ),
          ],
        )),
    ),
  );
}