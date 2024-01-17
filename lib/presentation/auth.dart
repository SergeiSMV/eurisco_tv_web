import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';

import '../colors.dart';
import '../data/server_implementation.dart';
import 'main_screen.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {

  TextEditingController loginController = TextEditingController();
  TextEditingController passController = TextEditingController();
  Color buttonColor = const Color(0xFF96A0B7);
  bool isMobile = GetPlatform.isMobile;



  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    loginController.clear();
    passController.clear();
    loginController.dispose();
    passController.dispose();
  }



  @override
  Widget build(BuildContext context) {

    final messenger = ScaffoldMessenger.of(context);

    return Scaffold(
      body: ProgressHUD(
        barrierColor: Colors.white.withOpacity(0.7),
        padding: const EdgeInsets.all(20.0),
        child: Builder(
          builder: (context) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  opacity: 0.7,
                  image: AssetImage('lib/images/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: 0.3,
                          child: Image.asset('lib/images/eurisco_tv.png', scale: isMobile ? 2.5 : 1.5)
                        ),
                        Center(child: Text(isMobile ? 'web mobile' : 'web browser', style: firm12)),
                        const SizedBox(height: 25,),
                        
                        // поле ввода логина
                        Padding(
                          padding: const EdgeInsets.only(left: 35, right: 35),
                          child: Container(
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
                              autofillHints: const [AutofillHints.name],
                              controller: loginController,
                              style: firm15,
                              minLines: 1,
                              obscureText: false,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle: grey15,
                                hintText: 'ID клиента',
                                prefixIcon: const IconTheme(data: IconThemeData(color: Color(0xFF687797)), child: Icon(Icons.person)),
                                isCollapsed: true,
                              ),
                              onChanged: (_){ setState(() { }); },
                              onSubmitted: (value) { setState(() { }); },
                            ),
                          ),
                        ),
                    
                        const SizedBox(height: 10),
                                
                        // поле ввода пароля
                        Padding(
                          padding: const EdgeInsets.only(left: 35, right: 35),
                          child: Container(
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
                              autofillHints: const [AutofillHints.password],
                              controller: passController,
                              style: firm15,
                              minLines: 1,
                              obscureText: true,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintStyle: grey15,
                                hintText: 'пароль',
                                prefixIcon: const IconTheme(data: IconThemeData(color: Color(0xFF687797)), child: Icon(Icons.lock)),
                                isCollapsed: true
                              ),
                              onChanged: (_){ setState(() { }); },
                              onSubmitted: (_) { setState(() { }); },
                            ),
                          ),
                        ),
                    
                        const SizedBox(height: 20),

                        // кнопка входа
                        loginController.text.isEmpty || passController.text.isEmpty ? const SizedBox.shrink() :
                        Padding(
                          padding: const EdgeInsets.only(left: 35, right: 35),
                          child: MouseRegion(
                            // onEnter: (_) { log('i am onEnter'); },
                            onEnter: (_) => setState(() => buttonColor = const Color(0xFF687797)),
                            onExit: (_) => setState(() => buttonColor = const Color(0xFF96A0B7)),
                            child: InkWell(
                              onTap: () async { 
                                Map authData = {'login': loginController.text.toString(), 'password': passController.text.toString()};
                                FocusScope.of(context).unfocus();
                                final progress = ProgressHUD.of(context);
                                progress?.showWithText('проверка...');
                                await ServerImpl().auth(authData).then((value) {
                                  progress?.dismiss();
                                  value == 'no connection' ? messenger._toast('отсутствует соединение с сервером') : 
                                    value == 'admitted' ? { 
                                      loginController.clear(), 
                                      passController.clear(),
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainScreen()))
                                      // isMobile ?
                                      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainMobile())) :
                                      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const WebMain()))
                                    } : { messenger._toast('доступ запрещен') };
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.circular(5)),
                                height: 35,
                                width: 300,
                                child: Center(child: Text('вход', style: white14)),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Center(child: Text('Все права защищены©. ООО ЭВРИСКО, 2023.', style: firm10)),
                        const SizedBox(height: 20),

                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}

extension on ScaffoldMessengerState {
  void _toast(String message){
    showSnackBar(
      SnackBar(
        content: Text(message), 
        duration: const Duration(seconds: 4),
      )
    );
  }
}