//
//  PrintItemModel.swift
//  flutter_bluetooth_print_plugin
//
//  Created by Ning Li on 2019/12/9.
//

/// 打印内容类型
///
/// - QRCode: 二维码
enum PrintItemEnum: Int {
    case QRCode     = 10
    case text       = 20
}

/// 打印配置信息
class PrintItemModel: Decodable {
    var x: CGFloat = 0
    var y: CGFloat = 0
    var width: CGFloat = 0
    var height: CGFloat = 0
    /// 内容类型
    var itemEnum: CommonModel?
    /// 内容
    var value: String?
    /// 字体大小
    var fontSize: CGFloat?
    
    /// 内容类型
    var itemType: PrintItemEnum {
        return PrintItemEnum(rawValue: itemEnum?.id ?? 10)!
    }
}
