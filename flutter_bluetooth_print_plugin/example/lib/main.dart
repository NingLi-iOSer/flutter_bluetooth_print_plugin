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
  List<Map> peripheralInfoList = [];

  @override
  void initState() {
    super.initState();

    FlutterBluetoothPrintPlugin.receivePeripheralInfo((value) {
      setState(() {
        peripheralInfoList.add(value);
      });
    });
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
                child: Text(_getBluetoothStateText()),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: peripheralInfoList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(peripheralInfoList[index]['name']),
                      subtitle: Text(peripheralInfoList[index]['UUID']),
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

  // 扫描设备
  _scanPeripheral() async {
    FlutterBluetoothPrintPlugin.scanPeripheral(null);
  }
}
