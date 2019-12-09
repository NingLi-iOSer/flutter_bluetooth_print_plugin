import Flutter
import UIKit

public class SwiftFlutterBluetoothPrintPlugin: NSObject, FlutterPlugin {
    
    static var peripherals = [CBPeripheral]()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftFlutterBluetoothPrintPlugin()
        
        // 更新蓝牙状态
        let stateChannel = FlutterMethodChannel(name: "com.MingNiao/did_update_state", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: stateChannel)
        
        // 停止扫描
        let stopChannel = FlutterMethodChannel(name: "com.MingNiao/stop_scan", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: stopChannel)
        
        // 关闭连接
        let closeChannel = FlutterMethodChannel(name: "com.MingNiao/close", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: closeChannel)
        
        // 扫描外设
        let scanChannel = FlutterBasicMessageChannel(name: "com.MingNiao/scan", binaryMessenger: registrar.messenger())
        scanChannel.setMessageHandler({ (message, _) in
            var services = [CBUUID]()
            if let uuid = message as? String {
                services.append(CBUUID(string: uuid))
            }
            BluetoothConnectTool.scanForPeripherals(services: services, option: nil) { (peripheral, _, _) in
                guard let peripheral = peripheral,
                    !(peripheral.name ?? "").isEmpty,
                    !(peripherals.map { $0.identifier }).contains(peripheral.identifier)
                    else {
                        return
                }
                peripherals.append(peripheral)
                let info: [String: String] = ["UUID": peripheral.identifier.uuidString, "name": peripheral.name ?? ""]
                // 回调设备 UUID, 设备名称
                scanChannel.sendMessage(info)
            }
        })
        
        // 连接外设
        let connectChannel = FlutterMethodChannel(name: "com.MingNiao/connect", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: connectChannel)
        
        // 连接外设回调连接状态
        let connectStateChannel = FlutterBasicMessageChannel(name: "com.MingNiao/connect_state", binaryMessenger: registrar.messenger())
        connectStateChannel.setMessageHandler { (message, _) in
            guard let dict = message as? [String: Any],
                let uuid = dict["uuid"] as? String,
                let timeout = dict["timeout"] as? UInt,
                let peripheral = (SwiftFlutterBluetoothPrintPlugin.peripherals.filter { $0.identifier.uuidString.elementsEqual(uuid) }).first
                else {
                    return
            }
            BluetoothConnectTool.connectPeripheral(peripheral, options: nil, timeout: timeout) { (state) in
                connectStateChannel.sendMessage(state.rawValue)
            }
        }
        
        // 获取打印指令
        let commandChannel = FlutterMethodChannel(name: "com.MingNiao/command", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: commandChannel)
        
        // 写数据
        let writeDataChannel = FlutterMethodChannel(name: "com.MingNiao/write_data", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: writeDataChannel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "didUpdateState": // 更新蓝牙状态
            BluetoothConnectTool.didUpdateState { (state) in
                result(state)
            }
        case "stopScan": // 停止扫描
            BluetoothConnectTool.stopScan()
        case "close": // 关闭连接
            BluetoothConnectTool.close()
        case "connect": // 连接外设
            guard let args = call.arguments as? [String],
                let uuid = args.first,
                let peripheral = (SwiftFlutterBluetoothPrintPlugin.peripherals.filter { $0.identifier.uuidString.elementsEqual(uuid) }).first
                else {
                    return
            }
            BluetoothConnectTool.connectPeripheral(peripheral, options: nil)
        case "command": // 获取打印指令
            guard let args = call.arguments as? [Any],
                let infos = args.first as? [Any],
                let dpi = args.last as? CGFloat
                else {
                    return
            }
            let commandTool = TscCommandTool(infos: infos)
            if let commands = commandTool?.createCommands(dpi: dpi) {
                result(commands)
            }
        case "writeData": // 写数据
            guard let dict = call.arguments as? [String: Any],
                let datas = dict["data"] as? [Data]
                else {
                    return
            }
            datas.forEach { (data) in
                BluetoothConnectTool.writeData(data)
            }
        default:
            break
        }
    }
}
