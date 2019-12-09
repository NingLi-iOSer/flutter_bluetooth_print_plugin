import 'dart:async';
import 'dart:ffi';

import 'package:flutter/services.dart';

// 蓝牙状态
enum BluetoothState {
  unknown,//未知
  resetting,//重置中
  unsupported,//不支持
  unauthorized,//未授权
  poweredOff,//已关闭
  poweredOn //已开启
}

// 设备连接状态
enum ConnectState {
  not_found_device,//未找到设备
  disconnect,//断开连接
  connecting,//连接中
  connected,//连接上
  timeout,//连接超时
  failure // 连接失败
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

  // 通知开始扫描外设
  static void scanPeripheral(String uuid) {
    _scanChannel.send(uuid);
  }

  // 接收扫描到的设备信息
  static receivePeripheralInfo(listener(Map info)) {
    _scanChannel.setMessageHandler((value) async {
      listener(value);
    });
  }

  // 连接外设
  static const MethodChannel _connectChannel = const MethodChannel('com.MingNiao/connect');

  static void connectPeripheral(String uuid) {
    _connectChannel.invokeMethod('connect', uuid);
  }

  // 连接外设回调连接状态
  static const BasicMessageChannel _connectStateChannel = const BasicMessageChannel('com.MingNiao/connect_state', StandardMessageCodec());
  
  // 通知连接外设
  static void startConnectPeripheral(String uuid, int timeout) {
    _connectStateChannel.send({'uuid': uuid, 'timeout': timeout});
  }

  // 接收连接状态
  static receiveConnectState(listener(ConnectState state)) {
    _connectStateChannel.setMessageHandler((stateValue) async {
      ConnectState state = ConnectState.values.where((value) {
        return value.index == stateValue;
      }).first;
      listener(state);
    });
  }

  // 获取打印指令
  static const MethodChannel _commandChannel = const MethodChannel('com.MingNiao/command');

  static Future<List> getPrintCommandData(List infos) async {
    List commands = await _commandChannel.invokeMethod('command', infos);
    return commands;
  }

  // 写数据
  static const MethodChannel _writeDataChannel = const MethodChannel('com.MingNiao/command');

  static writeDatas(List datas) {
    _writeDataChannel.invokeMethod('writeDatas', datas);
  }
}
