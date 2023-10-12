import 'package:fluttertoast/fluttertoast.dart';

class Toast {
  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,

      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    
      fontSize: 16.0,
    );
  }
}
