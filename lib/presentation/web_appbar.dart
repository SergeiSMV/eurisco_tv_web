import 'dart:async';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../colors.dart';
import '../data/providers.dart';
import '../data/server_implementation.dart';


class WebAppBar extends ConsumerStatefulWidget {
  final BuildContext mainContext;
  const WebAppBar({super.key, required this.mainContext});

  @override
  ConsumerState<WebAppBar> createState() => _WebAppBarState();
}

class _WebAppBarState extends ConsumerState<WebAppBar> {


  Timer timer = Timer(const Duration(seconds: 0), () { null; });
  String _timeString = '';

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  @override
  void dispose() async {
    timer.cancel();
    super.dispose();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH·mm·ss').format(dateTime);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
      child: Row(
        children: [
          Image.asset('lib/images/eurisco_tv.png', scale: 2),
          const SizedBox(width: 20,),
          Expanded(
            child: Text(
              _timeString, 
              style: TextStyle(color: const Color(0xFF02344a).withOpacity(0.2), fontSize: 80, fontWeight: FontWeight.w600), 
              overflow: TextOverflow.fade, 
              maxLines: 1,
            ),
          ),
          Container(
            decoration: BoxDecoration(color: firmColor, borderRadius: BorderRadius.circular(5)),
            height: 40,
            // width: 300,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: TextButton(
                onPressed: () async {
                  /*
                  final progress = ProgressHUD.of(widget.mainContext);
                  FilePickerResult? picked = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['mp4', 'jpg', 'jpeg'], allowMultiple: false, withData: true);
                  if (picked != null) {
                    progress?.showWithText('гномы потащили\nфайл на сервер');
                    String result = await ServerImpl().uploadFile(picked);
                    if (result == 'done'){
                      progress?.dismiss();
                      return ref.refresh(getWebConfigProvider);
                    } else {
                      progress?.dismiss();
                    }
                  }
                  */
                }, 
                child: Text('добавить', style: white14,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}