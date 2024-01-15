import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import 'web_appbar.dart';
import 'web_deviceconfig.dart';
import 'web_devicename.dart';
import 'web_devicepannel.dart';


class WebMain extends ConsumerStatefulWidget {
  const WebMain({super.key});

  @override
  ConsumerState<WebMain> createState() => _WebMainState();
}



class _WebMainState extends ConsumerState<WebMain> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ref.watch(getWebConfigProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        WebAppBar(mainContext: context,),
                        const WebDevicePannel(),
                        const WebDeviceName(),
                        const SizedBox(height: 50,)
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 2,
                    child: WebDeviceConfig()
                  ),
                ],
              )
            );
          }
        ),
      ),
    );
  }


}