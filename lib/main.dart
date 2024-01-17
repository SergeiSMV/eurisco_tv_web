import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/hive_implementation.dart';
import 'presentation/auth.dart';
import 'presentation/main_screen.dart';

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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', ''), // Russian
      ],
      home: authRouter(authData),
    );
  }
}

Widget authRouter(Map authData){
  // bool isMobile = GetPlatform.isMobile;
  late Widget router;
  if (authData.isEmpty){
    router = const Auth();
  } else {
    router = const MainScreen();
  }
  return router;
}