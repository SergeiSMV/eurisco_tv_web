import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../colors.dart';
import '../../data/providers.dart';
import '../../domain/config_model/config_model.dart';
import '../web_fullscreenpreview.dart';
import 'empty_content.dart';


class ContentMobile extends ConsumerStatefulWidget {
  const ContentMobile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContentMobileState();
}

class _ContentMobileState extends ConsumerState<ContentMobile> {

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
        Map deviceConfig = allConfigs[deviceId]['content'];

        return deviceConfig.isEmpty ? emptyContent(context) :
         Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: deviceConfig.length,
            itemBuilder: (context, index){

              String name = deviceConfig.keys.elementAt(index);
              Map<String, dynamic> value = deviceConfig[name];

              ConfigModel config = ConfigModel(configModel: value);
              String extention = name.split('.')[1];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
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
                                clipBehavior: Clip.antiAlias,
                                fit: BoxFit.cover,
                                child: Image.network(config.preview)
                              )
                            ),

                            config.show ? const SizedBox.shrink() :
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.7),
                              )
                            ),

                            config.show ? const SizedBox.shrink() :
                            const Positioned(
                              left: 20,
                              top: 20,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Icon(
                                  Icons.lock,
                                  size: 30,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),

                            Center(
                              child: InkWell(
                                onTap: (){ 
                                  bool isImage = extention == 'mp4' ? false : true;
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => WebFullScreenPreview(link: config.stream, isImage: isImage,)));
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
                              const SizedBox(width: 10,),
                              Expanded(
                                child: Text(name, 
                                style: darkFirm13, 
                                overflow: TextOverflow.ellipsis, 
                                maxLines: 1,
                              )
                              ),
                              IconButton(
                                onPressed: (){
                                  // editDialog(context, index, durController, startController, endController);
                                }, 
                                icon: Icon(
                                  Icons.more_vert,
                                  // Icons.settings,
                                  size: 25,
                                  color: firmColor,
                                ),
                              ),
                              // const SizedBox(width: 10,),
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
}