import 'dart:async';

import 'package:flutter/services.dart';

enum BluetoothState {
  unknown,
  resetting,
  unsupported,
  unauthorized,
  poweredOff,
  poweredOn
}

class FlutterBluetoothPrintPlugin {
  // 获取蓝牙状态
  static const MethodChannel _stateChannel =
      const MethodChannel('com.MingNiao/did_update_state');

  static Future<BluetoothState> get bluetoothState async {
    final int stateValue = await _stateChannel.invokeMethod('didUpdateState');
    BluetoothState state = BluetoothState.values.where((value) {
      return value.index == stateValue;
    }).first;
    return state;
  }

  // 停止扫描
  static const MethodChannel _stopChannel = const MethodChannel('com.MingNiao/stop_scan');

  static stopScan() {
    _stopChannel.invokeMethod('stopScan');
  }

  // 关闭连接
  static const MethodChannel _closeChannel = const MethodChannel('com.MingNiao/close');
  
  static close() {
    _closeChannel.invokeMethod('close');
  }

  // 扫描外设
  static const BasicMessageChannel _scanChannel = const BasicMessageChannel('com.MingNiao/scan', StandardMessageCodec());

  /*
   * @description: 通知开始扫描外设
   */
  static void scanPeripheral(String uuid) {
    _scanChannel.send(uuid);
  }

  /*
   * @description: 接收扫描到的设备信息
   */  
  static receivePeripheralInfo(listener(Map info)) {
    _scanChannel.setMessageHandler((value) async {
      listener(value);
    });
  }
}
