import Flutter
import UIKit

public class SwiftFlutterBluetoothPrintPlugin: NSObject, FlutterPlugin {
    
    static var peripherals = [CBPeripheral]()
    static var scanChannel: FlutterBasicMessageChannel?
    
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
        scanChannel = FlutterBasicMessageChannel(name: "com.MingNiao/scan", binaryMessenger: registrar.messenger())
        scanChannel?.setMessageHandler({ (message, reply) in
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
                scanChannel?.sendMessage(info)
            }
        })
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
        default:
            break
        }
    }
}
