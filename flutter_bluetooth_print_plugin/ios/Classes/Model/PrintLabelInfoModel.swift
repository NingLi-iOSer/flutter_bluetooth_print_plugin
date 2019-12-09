//
//  PrintLabelInfoModel.swift
//  flutter_bluetooth_print_plugin
//
//  Created by Ning Li on 2019/12/9.
//

/// 打印标签信息模型
class PrintLabelInfoModel: Decodable {
    /// 标签宽度
    var width: CGFloat = 0
    /// 标签高度
    var height: CGFloat = 0
    /// 内容数组
    var itemConfigList: [PrintItemModel]?
}
