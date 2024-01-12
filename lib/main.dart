import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/hive_implementation.dart';
import 'presentation/auth.dart';
import 'presentation/mobile/main_mobile.dart';
import 'presentation/web_main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('hiveStorage');
  Map authData = await HiveImpl().getAuthData();
  runApp(ProviderScope(child: App(authData: authData,)));
}


class App extends StatelessWidget {
  final Map authData;
  const App({Key? key, required this.authData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF687797),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent)
          ),
        )
      ),
      home: authRouter(authData),
    );
  }
}

Widget authRouter(Map authData){
  bool isMobile = GetPlatform.isMobile;
  late Widget router;
  if (authData.isEmpty){
    router = const Auth();
  } else {
    router = isMobile ? const MainMobile() : const WebMain();
  }
  return router;
}

/*
Future request(Map authData) async {
  bool isConnected = true;
  WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(ws));
  await channel.ready.onError((error, stackTrace) => isConnected = false);

  if(isConnected == false){
    return 'сервер отключен';
  } else {
    try{
      dynamic result;
      channel.sink.add(jsonEncode('hello websocket'));
      await channel.stream.single.then((value) {
        result = jsonDecode(value);
        return result;
      });
      return result;
    } on Error catch (_){
      return '$_ (server ERROR)';
    } on Exception catch (_){
      return '$_ (server EXCEPTION)';
    }
  }
}
*/