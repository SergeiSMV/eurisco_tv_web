import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../colors.dart';
import '../../data/providers.dart';
import 'web_editdialog.dart';
import '../fullscreenpreview.dart';

class WebDeviceConfig extends ConsumerStatefulWidget {
  const WebDeviceConfig({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebDeviceConfigState();
}

class _WebDeviceConfigState extends ConsumerState<WebDeviceConfig> {

  TextEditingController durController = TextEditingController();
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    durController.dispose();
    startController.dispose();
    endController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child){
        final allConfigs = ref.watch(configProvider);
        final deviceId = ref.watch(deviceIdProvider);
        List deviceConfig = allConfigs.isEmpty ? [] : allConfigs[deviceId]['content'];

        return allConfigs.isEmpty ? loading() :
          // Center(
          //   child: Text(
          //     'EMPTY', 
          //     style: TextStyle(color: firmColor, fontSize: 40, fontWeight: FontWeight.w600),
          //   )
          // ) 
          // :
          Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 600,
                childAspectRatio: 4/3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 1
              ),
              itemCount: deviceConfig.length,
              itemBuilder: (context, index){
                
                String extention = deviceConfig[index]['name'].split('.')[1];
                String duration = deviceConfig[index]['duration'].toString();
                String periodic = deviceConfig[index]['start'] == '00:00' && deviceConfig[index]['end'] == '23:59' ?
                  'круглосуточно' : 'с ${deviceConfig[index]['start']} до ${deviceConfig[index]['end']}';
                String fileName = deviceConfig[index]['name'].split('.')[0].toString();
                bool show = deviceConfig[index]['show'];

                return Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              AspectRatio(
                                aspectRatio: 16.0 / 9.0,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.network(deviceConfig[index]['preview'])
                                )
                              ),

                              show ? const SizedBox.shrink() :
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(0.7),
                                )
                              ),

                              show ? const SizedBox.shrink() :
                              const Positioned(
                                left: 20,
                                top: 20,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Icon(
                                    Icons.lock,
                                    size: 50,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),

                              Center(
                                child: InkWell(
                                  onTap: (){ 
                                    bool isImage = extention == 'mp4' ? false : true;
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => FullScreenPreview(link: deviceConfig[index]['stream'], isImage: isImage,)));
                                    // WebFullScreenPreview(link: deviceConfig[index]['stream'], isImage: isImage,);
                                  },
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: firmColor,
                                    child: Icon(
                                      extention == 'mp4' ? Icons.play_arrow : Icons.photo,
                                      size: extention == 'mp4' ? 40 : 35,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ) 
                            ],
                          ),
                        ),
                  
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade400,
                                spreadRadius: 0.0,
                                blurRadius: 0.5,
                                offset: const Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text('имя: $fileName', style: firm14, overflow: TextOverflow.fade, maxLines: 1,)
                                    ),
                                    const SizedBox(height: 3,),

                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        show ?
                                        'период показа: $periodic' : 'период показа: -', 
                                        style: firm14, overflow: TextOverflow.fade, maxLines: 1,
                                      )
                                    ),
                                    const SizedBox(height: 3,),
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        show ?
                                          duration == 'null' ? 'длительность: согласно видео' : 'длительность: $duration секунд' :
                                          'длительность: -', 
                                        style: firm14, overflow: TextOverflow.fade, maxLines: 1,
                                      )
                                    ),
                                    const SizedBox(height: 3,),
                                  ],
                                ),

                                const Spacer(),

                                InkWell(
                                  onTap: (){ editDialog(context, index, durController, startController, endController); },
                                  child: Icon(
                                    Icons.settings,
                                    size: 25,
                                    color: firmColor,
                                  ),
                                ),

                                const SizedBox(width: 10,),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            ),
          );
      },
    );
  }

  Widget loading(){
    return Center(
      child: SizedBox(
        height: 300,
        width: 300,
        child: DotLottieLoader.fromAsset('lib/images/loading.lottie',
          frameBuilder: (ctx, dotlottie) {
            // return dotlottie != null ? Lottie.memory(dotlottie.animations.values.single) : Container();
            return SizedBox(
              height: 10,
              width: 10,
              child: dotlottie != null ? Lottie.memory(dotlottie.animations.values.single) : Container(),
            );
        }),
      ),
    );
  }

}