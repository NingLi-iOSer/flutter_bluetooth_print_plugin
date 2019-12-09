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
    
    /// 扫描外设
    /// - Parameters:
    ///   - services: 需要发现外设的UUID，设置为nil则发现周围所有外设
    ///   - option: 其它可选操作
    ///   - discover: 发现的设备
    static func scanForPeripherals(services: [CBUUID], option: [String: Any]?, discover: @escaping (_ peripheral: CBPeripheral?, _ advertisementData: [String: Any]?, _ RSSI: NSNumber?) -> Void) {
        ConnecterManager.sharedInstance()?.scanForPeripherals(withServices: services, options: option, discover: discover)
    }
    
    /// 连接外设
    /// - Parameters:
    ///   - peripheral: 需连接的外设
    ///   - options: 其它可选操作
    static func connectPeripheral(_ peripheral: CBPeripheral, options: [String: Any]?) {
        ConnecterManager.sharedInstance()?.connect(peripheral, options: options)
    }
    
    /// 连接外设
    /// - Parameters:
    ///   - peripheral: 需连接的外设
    ///   - options: 其它可选操作
    ///   - timeout: 连接超时时间
    ///   - connectState: 连接状态
    static func connectPeripheral(_ peripheral: CBPeripheral, options: [String: Any]?, timeout: UInt, connectState: @escaping (_ state: ConnectState) -> Void) {
        ConnecterManager.sharedInstance()?.connect(peripheral, options: options, timeout: timeout, connectBlack: connectState)
    }
    
    /// 向输出流中写入数据
    /// - Parameter data: 需要写入的数据
    static func writeData(_ data: Data) {
        ConnecterManager.sharedInstance()?.write(data)
    }
}
