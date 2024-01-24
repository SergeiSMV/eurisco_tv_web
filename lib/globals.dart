import 'package:logger/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

var log = Logger();
List<String> allowedExtensions = ['mp4', 'jpg', 'jpeg'];

double screenWidthParam = 400.00;

WebSocketChannel? wsChannel;