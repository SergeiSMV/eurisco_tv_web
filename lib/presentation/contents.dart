import 'package:eurisco_tv_web/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../data/providers.dart';
import '../domain/config_model/config_model.dart';
import 'fullscreenpreview.dart';
import 'content_settings/content_settings.dart';

class Contents extends ConsumerWidget {
  final String deviceID;
  const Contents({super.key, required this.deviceID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final editConfigs = ref.watch(editConfigProvider);

    Map deviceContent = editConfigs[deviceID]['content'];
    String deviceName = editConfigs[deviceID]['name'];
    
    return MasonryGridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverSimpleGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 600
      ),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemCount: deviceContent.length,
      itemBuilder: (context, index){
        var entry = deviceContent.entries.elementAt(index);
        return content(context, entry.key, entry.value, deviceName, editConfigs);
      },
    );
  }



  Widget content(BuildContext context, String contentName, Map<String, dynamic> contentConfig, String deviceName, Map editConfigs){

    ConfigModel config = ConfigModel(configModel: contentConfig);
    String extention = contentName.split('.')[1];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 5, left: 5),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [

                // изображение контента
                AspectRatio(
                  aspectRatio: 16.0 / 9.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)
                      ),
                      image: DecorationImage(
                        image: NetworkImage(config.preview),
                        fit: BoxFit.cover
                      ),
                      color: Colors.white,
                    ),
                    // child: Image.network(config.preview)
                  )
                ),

                // затемнение если запрет к показу
                config.show ? const SizedBox.shrink() :
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)
                      ),
                      color: Colors.black.withOpacity(0.7),
                    ),
                  )
                ),

                // иконка замка если запрет к показу
                config.show ? const SizedBox.shrink() :
                const Positioned(
                  left: 20,
                  top: 20,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Icon(
                      Icons.visibility_off_outlined,
                      size: 30,
                      color: Colors.redAccent,
                    ),
                  ),
                ),

                // кнопка возпроизведения или предпросмотра
                Center(
                  child: InkWell(
                    onTap: (){ 
                      bool isImage = extention == 'mp4' ? false : true;
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => FullScreenPreview(link: config.stream, isImage: isImage,)));
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
      
            // контейнер с информацией о контенте и кнопкой редактирования
            Container(
              padding: EdgeInsets.zero,
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
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(0),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: <Color>[
                            const Color(0xFFcddafc),
                            const Color(0xFFcddafc).withOpacity(0.6),
                            const Color(0xFFcddafc).withOpacity(0.3),
                            const Color(0xFFcddafc).withOpacity(0.0)
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text(contentName, style: firm14, overflow: TextOverflow.ellipsis,)),
                      )
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text('показ: ${config.show ? 'разрешен' : 'запрещен'}', style: firm14, overflow: TextOverflow.ellipsis,),
                    ),
                    const SizedBox(height: 3),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text('длительность: ${config.duration == 0 ? 'согласно видео' : '${config.duration.toString()} сек.'}', style: firm14, overflow: TextOverflow.ellipsis,),
                    ),
                    const SizedBox(height: 3),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text('дата начала: ${config.startDate}', style: firm14, overflow: TextOverflow.ellipsis,),
                    ),
                    const SizedBox(height: 3),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text('дата окончания: ${config.endDate}', style: firm14, overflow: TextOverflow.ellipsis,),
                    ),
                    const SizedBox(height: 3),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text('время начала: ${config.startTime}', style: firm14, overflow: TextOverflow.ellipsis,),
                    ),
                    const SizedBox(height: 3),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text('время окончания: ${config.endTime}', style: firm14, overflow: TextOverflow.ellipsis,),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                        // color: Color(0xFFcddafc),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8)
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: <Color>[
                            const Color(0xFFcddafc),
                            const Color(0xFFcddafc).withOpacity(0.6),
                            const Color(0xFFcddafc).withOpacity(0.3),
                            const Color(0xFFcddafc).withOpacity(0.0)
                          ],
                        ),
                      ),
                      child: TextButton(
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContentSettings(
                            editConfigs: Map.from(editConfigs),
                            contentName: contentName, 
                            deviceID: deviceID,
                          )));
                        }, 
                        child: Center(child: Text('редактировать', style: firm14, overflow: TextOverflow.ellipsis,)),
                      ),
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
