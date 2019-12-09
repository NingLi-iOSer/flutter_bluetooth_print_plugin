import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_print_plugin/flutter_bluetooth_print_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // 蓝牙状态
  BluetoothState _bluetoothState = BluetoothState.unknown;
  // 设备信息
  List<Map> _peripheralInfoList = [];
  // 设备连接状态
  ConnectState _connectState = ConnectState.not_found_device;

  @override
  void initState() {
    super.initState();
    FlutterBluetoothPrintPlugin.receivePeripheralInfo((value) {
      setState(() {
        _peripheralInfoList.add(value);
      });
    });

    FlutterBluetoothPrintPlugin.receiveConnectState((value) {
      setState(() {
        _connectState = value;
      });
    });
  }

  @override
  void dispose() {
    print('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: <Widget>[
                   RaisedButton(
                    child: Text('获取蓝牙状态'),
                    onPressed: () {
                      FlutterBluetoothPrintPlugin.bluetoothState.then((value) {
                        setState(() {
                          _bluetoothState = value;
                          if (value == BluetoothState.poweredOn) { // 扫描设备
                            _scanPeripheral();
                          }
                        });
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(_getConnectStateText()),
                  )
                 ],
               ),
              Container(
                child: Text(_getBluetoothStateText()),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _peripheralInfoList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        String uuid = _peripheralInfoList[index]['UUID'];
                        FlutterBluetoothPrintPlugin.startConnectPeripheral(uuid, 10);
                      },
                      child: ListTile(
                        title: Text(_peripheralInfoList[index]['name']),
                        subtitle: Text(_peripheralInfoList[index]['UUID']),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _getBluetoothStateText() {
    switch (_bluetoothState) {
      case BluetoothState.unknown:
        return '未知';
        break;
      case BluetoothState.unsupported:
        return '蓝牙不支持';
        break;
      case BluetoothState.unauthorized:
        return '蓝牙未授权';
        break;
      case BluetoothState.resetting:
        return '蓝牙正在重置';
        break;
      case BluetoothState.poweredOff:
        return '蓝牙未开启';
        break;
      case BluetoothState.poweredOn:
        return '蓝牙已开启';
        break;
      default:
        return '';
    }
  }

  String _getConnectStateText() {
    switch (_connectState) {
      case ConnectState.not_found_device:
        return '未发现设备';
        break;
      case ConnectState.connecting:
        return '正在连接...';
        break;
      case ConnectState.connected:
        return '连接成功';
        break;
      case ConnectState.failure:
        return '连接失败';
        break;
      case ConnectState.timeout:
        return '连接超时';
        break;
      default:
        return '';
    }
  }

  // 扫描设备
  _scanPeripheral() async {
    FlutterBluetoothPrintPlugin.scanPeripheral(null);
  }
}
