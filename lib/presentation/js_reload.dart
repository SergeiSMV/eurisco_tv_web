

import 'package:js/js.dart';

@JS()
external void reloadPage();

void refreshPage() {
  reloadPage();
}
