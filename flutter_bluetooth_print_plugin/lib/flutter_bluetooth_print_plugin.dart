import 'dart:async';

import 'package:flutter/services.dart';

class FlutterBluetoothPrintPlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_bluetooth_print_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
