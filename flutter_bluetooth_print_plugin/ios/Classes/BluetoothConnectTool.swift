//
//  BluetoothConnectTool.swift
//  flutter_bluetooth_print_plugin
//
//  Created by Ning Li on 2019/12/9.
//

struct BluetoothConnectTool {
    
    /// 更新蓝牙状态
    /// - Parameter state: 蓝牙状态
    static func didUpdateState(state: @escaping (_ state: Int) -> Void) {
        ConnecterManager.sharedInstance()?.didUpdateState(state)
    }
    
    /// 停止扫描
    static func stopScan() {
        ConnecterManager.sharedInstance()?.stopScan()
    }
    
    /// 关闭连接
    static func close() {
        ConnecterManager.sharedInstance()?.close()
    }
    
    static func scanForPeripherals(services: [CBUUID], option: [String: Any]?, discover: @escaping (_ peripheral: CBPeripheral?, _ advertisementData: [String: Any]?, _ RSSI: NSNumber?) -> Void) {
        ConnecterManager.sharedInstance()?.scanForPeripherals(withServices: services, options: option, discover: discover)
    }
}
