import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bluetooth_print_plugin/flutter_bluetooth_print_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_bluetooth_print_plugin');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterBluetoothPrintPlugin.platformVersion, '42');
  });
}
